import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/data/models/detection_result.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/helper_functions/helper.dart';
import 'package:panoramicai/utils/helper_functions/image_processing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<Map<String, dynamic>> runNumberingPipeline(
  Map<String, dynamic> args,
) async {
  Uint8List modelBytes = args['modelBytes'];
  Uint8List imageBytes = args['imageBytes'];

  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) throw Exception("Gagal decode gambar");

  final int origW = originalImage.width;
  final int origH = originalImage.height;

  final Map<String, dynamic> prepResult = processNumberingFullInIsolate({
    'image': originalImage,
  });
  final Float32List input = prepResult['floatData'];
  final double scale = prepResult['scale'];
  final int padLeft = prepResult['padLeft'];
  final int padTop = prepResult['padTop'];

  final interpreter = Interpreter.fromBuffer(modelBytes);
  final inputShape = interpreter.getInputTensors()[0].shape;
  final outputShape = interpreter.getOutputTensors()[0].shape;
  var output = Float32List(
    outputShape.reduce((a, b) => a * b),
  ).reshape(outputShape);

  interpreter.run(input.reshape(inputShape), output);

  interpreter.close();

  List<List<double>> preds = List<List<double>>.from(
    (output[0] as List).map((e) => List<double>.from(e as List)),
  );

  if (preds.length == 8400) {
    var transposed = List.generate(
      preds[0].length,
      (i) => List<double>.filled(preds.length, 0.0),
    );
    for (int i = 0; i < preds.length; i++) {
      for (int j = 0; j < preds[0].length; j++) {
        transposed[j][i] = preds[i][j];
      }
    }
    preds = transposed;
  }

  List<DetectionResult> tempDetections = [];
  int numBoxes = preds[0].length;
  int numElements = preds.length;

  bool isNormalized = true;
  for (int i = 0; i < numBoxes && i < 100; i++) {
    if (preds[0][i] > 2.0) {
      isNormalized = false;
      break;
    }
  }

  for (int i = 0; i < numBoxes; i++) {
    double score = 0;
    int classId = -1;
    for (int c = 4; c < numElements; c++) {
      if (preds[c][i] > score) {
        score = preds[c][i];
        classId = c - 4;
      }
    }

    if (score > 0.25) {
      double cx = preds[0][i];
      double cy = preds[1][i];
      double w = preds[2][i];
      double h = preds[3][i];

      if (isNormalized) {
        cx *= 640;
        cy *= 640;
        w *= 640;
        h *= 640;
      }

      double x1 = (cx - w / 2 - padLeft) / scale;
      double y1 = (cy - h / 2 - padTop) / scale;
      double x2 = (cx + w / 2 - padLeft) / scale;
      double y2 = (cy + h / 2 - padTop) / scale;

      tempDetections.add(
        DetectionResult(
          box: Rect.fromLTRB(
            x1.clamp(0, origW.toDouble()),
            y1.clamp(0, origH.toDouble()),
            x2.clamp(0, origW.toDouble()),
            y2.clamp(0, origH.toDouble()),
          ),
          score: score,
          classId: classId,
          className: getToothNumber(classId),
          groupName: classId <= 34 ? "Permanent" : "Sulung",
          color: classId <= 34
              ? const Color(0xFFFF1493)
              : const Color(0xFFFFA500),
        ),
      );
    }
  }

  return {
    'detections': applyNMS(tempDetections),
    'width': origW.toDouble(),
    'height': origH.toDouble(),
  };
}

Future<Map<String, dynamic>> runCariesPipeline(
  Map<String, dynamic> args,
) async {
  Uint8List modelBytes = args['modelBytes'];
  Uint8List imageBytes = args['imageBytes'];

  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) throw Exception("Gagal decode gambar");

  final int origW = originalImage.width;
  final int origH = originalImage.height;

  final Map<String, dynamic> prepResult = processCariesFullInIsolate({
    'image': originalImage,
  });
  final List<Float32List> tilesData = List<Float32List>.from(
    prepResult['tilesData'],
  );
  final List<Map<String, int>> tilesMetadata = List<Map<String, int>>.from(
    prepResult['tilesMetadata'],
  );
  final int xMinOffset = prepResult['xMin'];
  final int yMinOffset = prepResult['yMin'];

  final interpreter = Interpreter.fromBuffer(modelBytes);
  List<DetectionResult> allDetections = [];

  for (int i = 0; i < tilesData.length; i++) {
    final input = tilesData[i];
    final meta = tilesMetadata[i];

    final outputShape = interpreter.getOutputTensors()[0].shape;
    final output = Float32List(
      outputShape.reduce((a, b) => a * b),
    ).reshape(outputShape);

    interpreter.run(input.reshape([1, 640, 640, 3]), output);

    for (int j = 0; j < 300; j++) {
      double score = output[0][j][4];
      if (score > 0.40) {
        double scaleX = meta['tw']! / 640.0;
        double scaleY = meta['th']! / 640.0;

        double x1Orig =
            (output[0][j][0] * 640 * scaleX) + meta['xStart']! + xMinOffset;
        double y1Orig =
            (output[0][j][1] * 640 * scaleY) + meta['yStart']! + yMinOffset;
        double x2Orig =
            (output[0][j][2] * 640 * scaleX) + meta['xStart']! + xMinOffset;
        double y2Orig =
            (output[0][j][3] * 640 * scaleY) + meta['yStart']! + yMinOffset;

        int classId = output[0][j][5].toInt();
        allDetections.add(
          DetectionResult(
            box: Rect.fromLTRB(x1Orig, y1Orig, x2Orig, y2Orig),
            score: score,
            classId: classId,
            className: getCariesClassName(classId),
            color: getCariesColor(classId),
          ),
        );
      }
    }
  }
  interpreter.close();

  return {
    'detections': applyNMS(allDetections),
    'width': origW.toDouble(),
    'height': origH.toDouble(),
  };
}

List<DetectionResult> applyNMS(List<DetectionResult> allDetections) {
  if (allDetections.isEmpty) return [];
  allDetections.sort((a, b) => b.score.compareTo(a.score));
  List<DetectionResult> selected = [];
  for (var det in allDetections) {
    bool skip = false;
    for (var sel in selected) {
      if (iou(det.box, sel.box) > 0.45) {
        skip = true;
        break;
      }
    }
    if (!skip) selected.add(det);
  }
  return selected;
}

double iou(Rect a, Rect b) {
  double intersectionWidth =
      (a.right < b.right ? a.right : b.right) -
      (a.left > b.left ? a.left : b.left);
  double intersectionHeight =
      (a.bottom < b.bottom ? a.bottom : b.bottom) -
      (a.top > b.top ? a.top : b.top);
  if (intersectionWidth <= 0 || intersectionHeight <= 0) return 0;
  double intersectionArea = intersectionWidth * intersectionHeight;
  double unionArea =
      (a.width * a.height) + (b.width * b.height) - intersectionArea;
  return intersectionArea / unionArea;
}

String getToothNumber(int id) {
  const map = {
    0: '11',
    1: '12',
    2: '13',
    3: '14',
    4: '15',
    5: '16',
    6: '17',
    7: '18',
    8: '19',
    9: '21',
    10: '22',
    11: '23',
    12: '24',
    13: '25',
    14: '26',
    15: '27',
    16: '28',
    17: '29',
    18: '31',
    19: '32',
    20: '33',
    21: '34',
    22: '35',
    23: '36',
    24: '37',
    25: '38',
    26: '41',
    27: '42',
    28: '43',
    29: '44',
    30: '45',
    31: '46',
    32: '47',
    33: '48',
    34: '49',
    35: '51',
    36: '52',
    37: '53',
    38: '54',
    39: '55',
    40: '61',
    41: '62',
    42: '63',
    43: '64',
    44: '65',
    45: '66',
    46: '71',
    47: '72',
    48: '73',
    49: '74',
    50: '75',
    51: '76',
    52: '81',
    53: '82',
    54: '83',
    55: '84',
    56: '85',
  };
  return map[id] ?? id.toString();
}

String getCariesClassName(int id) {
  const map = {0: "Dentin", 1: "Email", 2: "Pulpa", 3: "Sisa Akar"};
  return map[id] ?? "Unknown";
}

Color getCariesColor(int id) {
  const map = {
    0: Color(0xFF3296FF),
    1: Color(0xFF32FF32),
    2: Color(0xFFFF3232),
    3: Color(0xFFFF8700),
  };
  return map[id] ?? Colors.red;
}

class DeteksiController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxList<DetectionResult> detections = <DetectionResult>[].obs;

  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;

  RxDouble imageWidth = 0.0.obs;
  RxDouble imageHeight = 0.0.obs;

  Uint8List? _numberingModelBytes;
  Uint8List? _cariesModelBytes;

  @override
  void onInit() {
    super.onInit();
    _loadModelsToMemory();
  }

  Future<void> _loadModelsToMemory() async {
    isLoading.value = true;
    try {
      final numberingData = await rootBundle.load(
        'assets/models/model_numbering_detection.tflite',
      );
      _numberingModelBytes = numberingData.buffer.asUint8List();

      final cariesData = await rootBundle.load(
        'assets/models/model_caries_segmentation.tflite',
      );
      _cariesModelBytes = cariesData.buffer.asUint8List();
      debugPrint("Models loaded to memory successfully");
    } catch (e) {
      debugPrint("Error loading models: $e");
    }
    isLoading.value = false;
  }

  Future<bool> pickImageOnly(ImageSource source) async {
    selectedImage.value = null;
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
      return true;
    }
    return false;
  }

  Future<void> runDetection(DeteksiType type) async {
    imageWidth.value = 0;
    imageHeight.value = 0;
    if (selectedImage.value == null) return;

    isLoading.value = true;
    detections.clear();

    await Future.delayed(const Duration(milliseconds: 150));

    try {
      final Uint8List imageBytes = await selectedImage.value!.readAsBytes();

      if (type == DeteksiType.numbering) {
        if (_numberingModelBytes == null)
          throw Exception("Model numbering belum dimuat");

        final result = await compute(runNumberingPipeline, {
          'modelBytes': _numberingModelBytes!,
          'imageBytes': imageBytes,
        });

        detections.value = result['detections'];
        imageWidth.value = result['width'];
        imageHeight.value = result['height'];
      } else {
        if (_cariesModelBytes == null)
          throw Exception("Model caries belum dimuat");

        final result = await compute(runCariesPipeline, {
          'modelBytes': _cariesModelBytes!,
          'imageBytes': imageBytes,
        });

        detections.value = result['detections'];
        imageWidth.value = result['width'];
        imageHeight.value = result['height'];
      }
    } catch (e) {
      debugPrint("Error during detection: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Uint8List?> _generateMergedImage(DeteksiType type) async {
    if (selectedImage.value == null) return null;

    try {
      final Uint8List imageBytes = await selectedImage.value!.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      canvas.drawImage(originalImage, Offset.zero, Paint());

      for (var det in detections) {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..color = det.color;

        final rect = det.box;
        canvas.drawRect(rect, paint);

        String labelText = type == DeteksiType.numbering
            ? det.className
            : "${det.className} ${det.score.toStringAsFixed(2)}";

        final textStyle = ui.TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );

        final paragraphBuilder =
            ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.left))
              ..pushStyle(textStyle)
              ..addText(labelText);

        final paragraph = paragraphBuilder.build();
        paragraph.layout(const ui.ParagraphConstraints(width: 800));

        final textBgRect = Rect.fromLTWH(
          rect.left,
          rect.top - paragraph.height - 10,
          paragraph.maxIntrinsicWidth + 20,
          paragraph.height + 10,
        );
        canvas.drawRect(textBgRect, Paint()..color = det.color);

        canvas.drawParagraph(
          paragraph,
          Offset(rect.left + 10, rect.top - paragraph.height - 5),
        );
      }

      final ui.Picture picture = recorder.endRecording();
      final ui.Image mergedImage = await picture.toImage(
        originalImage.width,
        originalImage.height,
      );

      final ByteData? byteData = await mergedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error generating merged image: $e");
      return null;
    }
  }

  Future<void> simpanDeteksi(DeteksiType type) async {
    if (detections.isEmpty || selectedImage.value == null) return;

    try {
      isSaving.value = true;

      // In dummy mode, we can still try to save to Supabase if you want, 
      // but let's just mock the success for now as requested.
      await Future.delayed(const Duration(seconds: 1));

      MyHelperFunction.suksesToast('Data deteksi berhasil disimpan (Dummy Mode)!');

      Get.offAllNamed(PagesRoutes.RUTE_HOME);
    } catch (e) {
      debugPrint("Error saving detection: $e");
      MyHelperFunction.errorToast('Terjadi kesalahan saat menyimpan data dummy: $e');
    } finally {
      isSaving.value = false;
    }
  }
}
