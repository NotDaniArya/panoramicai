import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:panoramicai/features/deteksi/data/models/detection_result.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/utils/image_processing.dart';

class DeteksiController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxList<DetectionResult> detections = <DetectionResult>[].obs;
  RxBool isLoading = false.obs;

  Interpreter? _numberingInterpreter;
  Interpreter? _cariesInterpreter;

  @override
  void onInit() {
    super.onInit();
    _loadModels();
  }

  Future<void> _loadModels() async {
    isLoading.value = true;
    try {
      _numberingInterpreter = await Interpreter.fromAsset(
        'assets/models/model_numbering_detection.tflite',
      );
      _cariesInterpreter = await Interpreter.fromAsset(
        'assets/models/model_caries_segmentation.tflite',
      );
      debugPrint("Models loaded successfully");
    } catch (e) {
      debugPrint("Error loading models: $e");
    }
    isLoading.value = false;
  }

  Future<void> pickImage(ImageSource source, DeteksiType type) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
      await Future.delayed(const Duration(milliseconds: 100));
      runDetection(type);
    }
  }

  Future<void> runDetection(DeteksiType type) async {
    if (selectedImage.value == null) return;

    isLoading.value = true;
    detections.clear();

    try {
      final Uint8List bytes = await selectedImage.value!.readAsBytes();
      final img.Image? originalImage = await compute(decodeImageInIsolate, bytes);
      
      if (originalImage == null) {
        isLoading.value = false;
        return;
      }

      if (type == DeteksiType.numbering) {
        await _runNumberingDetection(originalImage);
      } else {
        await _runCariesDetection(originalImage);
      }
    } catch (e) {
      debugPrint("Error during detection: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _runNumberingDetection(img.Image originalImage) async {
    if (_numberingInterpreter == null) return;

    final Map<String, dynamic> result = await compute(processNumberingFullInIsolate, {
      'image': originalImage,
    });

    final Float32List input = result['floatData'];
    final double scale = result['scale'];
    final int padLeft = result['padLeft'];
    final int padTop = result['padTop'];

    final inputShape = _numberingInterpreter!.getInputTensors()[0].shape;
    final outputShape = _numberingInterpreter!.getOutputTensors()[0].shape;
    var output = Float32List(outputShape.reduce((a, b) => a * b)).reshape(outputShape);

    _numberingInterpreter!.run(input.reshape(inputShape), output);

    // Handle output shape [1, 57, 8400]
    List<List<double>> preds = List<List<double>>.from(
      (output[0] as List).map((e) => List<double>.from(e as List))
    );

    // Jika shape model adalah [8400, 57], lakukan transpose secara manual
    if (preds.length == 8400) {
      var transposed = List.generate(preds[0].length, (i) => List<double>.filled(preds.length, 0.0));
      for (int i = 0; i < preds.length; i++) {
        for (int j = 0; j < preds[0].length; j++) {
          transposed[j][i] = preds[i][j];
        }
      }
      preds = transposed;
    }

    _parseNumberingOutput(preds, scale, padLeft, padTop, originalImage.width, originalImage.height);
  }

  void _parseNumberingOutput(List<List<double>> output, double scale, int padLeft, int padTop, int origW, int origH) {
    List<DetectionResult> tempDetections = [];
    int numBoxes = output[0].length; 
    int numElements = output.length; 

    // Check if scaling is needed (normalized vs pixel coords)
    bool isNormalized = true;
    for (int i = 0; i < numBoxes && i < 100; i++) {
      if (output[0][i] > 2.0) {
        isNormalized = false;
        break;
      }
    }

    for (int i = 0; i < numBoxes; i++) {
      double score = 0;
      int classId = -1;
      for (int c = 4; c < numElements; c++) {
        if (output[c][i] > score) {
          score = output[c][i];
          classId = c - 4;
        }
      }

      if (score > 0.25) {
        double cx = output[0][i];
        double cy = output[1][i];
        double w = output[2][i];
        double h = output[3][i];

        if (isNormalized) {
          cx *= 640; cy *= 640; w *= 640; h *= 640;
        }

        // Map balik ke koordinat gambar asli
        double x1 = (cx - w / 2 - padLeft) / scale;
        double y1 = (cy - h / 2 - padTop) / scale;
        double x2 = (cx + w / 2 - padLeft) / scale;
        double y2 = (cy + h / 2 - padTop) / scale;

        tempDetections.add(DetectionResult(
          box: Rect.fromLTRB(
            x1.clamp(0, origW.toDouble()), 
            y1.clamp(0, origH.toDouble()), 
            x2.clamp(0, origW.toDouble()), 
            y2.clamp(0, origH.toDouble())
          ),
          score: score,
          classId: classId,
          className: _getToothNumber(classId),
          groupName: classId <= 34 ? "Permanent" : "Sulung",
          color: classId <= 34 ? const Color(0xFFFF1493) : const Color(0xFFFFA500),
        ));
      }
    }
    // NMS sangat krusial agar tidak ada hasil duplikat
    detections.value = _applyNMS(tempDetections);
  }

  Future<void> _runCariesDetection(img.Image originalImage) async {
    if (_cariesInterpreter == null) return;

    final Map<String, dynamic> result = await compute(processCariesFullInIsolate, {
      'image': originalImage,
    });

    final List<Float32List> tilesData = List<Float32List>.from(result['tilesData']);
    final List<Map<String, int>> tilesMetadata = List<Map<String, int>>.from(result['tilesMetadata']);
    final int xMinOffset = result['xMin'];
    final int yMinOffset = result['yMin'];

    List<DetectionResult> allDetections = [];

    for (int i = 0; i < tilesData.length; i++) {
      final input = tilesData[i];
      final meta = tilesMetadata[i];

      final outputShape = _cariesInterpreter!.getOutputTensors()[0].shape;
      final output = Float32List(outputShape.reduce((a, b) => a * b)).reshape(outputShape);

      _cariesInterpreter!.run(input.reshape([1, 640, 640, 3]), output);

      for (int j = 0; j < 300; j++) {
        double score = output[0][j][4];
        if (score > 0.40) {
          double scaleX = meta['tw']! / 640.0;
          double scaleY = meta['th']! / 640.0;

          double x1Orig = (output[0][j][0] * 640 * scaleX) + meta['xStart']! + xMinOffset;
          double y1Orig = (output[0][j][1] * 640 * scaleY) + meta['yStart']! + yMinOffset;
          double x2Orig = (output[0][j][2] * 640 * scaleX) + meta['xStart']! + xMinOffset;
          double y2Orig = (output[0][j][3] * 640 * scaleY) + meta['yStart']! + yMinOffset;

          allDetections.add(DetectionResult(
            box: Rect.fromLTRB(x1Orig, y1Orig, x2Orig, y2Orig),
            score: score,
            classId: output[0][j][5].toInt(),
            className: _getCariesClassName(output[0][j][5].toInt()),
            color: _getCariesColor(output[0][j][5].toInt()),
          ));
        }
      }
    }
    detections.value = _applyNMS(allDetections);
  }

  List<DetectionResult> _applyNMS(List<DetectionResult> allDetections) {
    if (allDetections.isEmpty) return [];
    
    // Urutkan berdasarkan score tertinggi
    allDetections.sort((a, b) => b.score.compareTo(a.score));
    
    List<DetectionResult> selected = [];
    for (var det in allDetections) {
      bool skip = false;
      for (var sel in selected) {
        // Jika overlap dengan kotak yang sudah dipilih > 45%, abaikan (hapus duplikat)
        if (_iou(det.box, sel.box) > 0.45) {
          skip = true;
          break;
        }
      }
      if (!skip) selected.add(det);
    }
    return selected;
  }

  double _iou(Rect a, Rect b) {
    double intersectionWidth = (a.right < b.right ? a.right : b.right) - (a.left > b.left ? a.left : b.left);
    double intersectionHeight = (a.bottom < b.bottom ? a.bottom : b.bottom) - (a.top > b.top ? a.top : b.top);
    if (intersectionWidth <= 0 || intersectionHeight <= 0) return 0;
    double intersectionArea = intersectionWidth * intersectionHeight;
    double unionArea = (a.width * a.height) + (b.width * b.height) - intersectionArea;
    return intersectionArea / unionArea;
  }

  String _getToothNumber(int id) {
    const map = {
      0: '11', 1: '12', 2: '13', 3: '14', 4: '15', 5: '16', 6: '17', 7: '18', 8: '19',
      9: '21', 10: '22', 11: '23', 12: '24', 13: '25', 14: '26', 15: '27', 16: '28', 17: '29',
      18: '31', 19: '32', 20: '33', 21: '34', 22: '35', 23: '36', 24: '37', 25: '38',
      26: '41', 27: '42', 28: '43', 29: '44', 30: '45', 31: '46', 32: '47', 33: '48', 34: '49',
      35: '51', 36: '52', 37: '53', 38: '54', 39: '55', 40: '61', 41: '62', 42: '63', 43: '64', 
      44: '65', 45: '66', 46: '71', 47: '72', 48: '73', 49: '74', 50: '75', 51: '76', 52: '81'
    };
    return map[id] ?? id.toString();
  }

  String _getCariesClassName(int id) {
    const map = {0: "Dentin", 1: "Email", 2: "Pulpa", 3: "Sisa Akar"};
    return map[id] ?? "Unknown";
  }

  Color _getCariesColor(int id) {
    const map = {
      0: Color(0xFF3296FF), 1: Color(0xFF32FF32), 2: Color(0xFFFF3232), 3: Color(0xFFFFFF00),
    };
    return map[id] ?? Colors.red;
  }

  @override
  void onClose() {
    _numberingInterpreter?.close();
    _cariesInterpreter?.close();
    super.onClose();
  }
}
