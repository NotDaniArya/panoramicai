import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:panoramicai/features/deteksi/data/models/detection_result.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/utils/constant/colors.dart';

class DeteksiScreen extends GetView<DeteksiController> {
  final DeteksiType type;

  const DeteksiScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          type == DeteksiType.numbering ? "Numbering Gigi" : "Karies Gigi",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: TColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  if (controller.selectedImage.value == null) {
                    return const Text("Tidak ada gambar yang dipilih");
                  }

                  // Menggunakan dimensi yang sudah disimpan dari controller.
                  // Menghilangkan fungsi _getImageSize dan FutureBuilder yang memakan RAM
                  if (controller.imageWidth.value == 0 ||
                      controller.imageHeight.value == 0) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final Size imageSize = Size(
                        controller.imageWidth.value,
                        controller.imageHeight.value,
                      );
                      final double screenAspectRatio =
                          constraints.maxWidth / constraints.maxHeight;
                      final double imageAspectRatio =
                          imageSize.width / imageSize.height;

                      double drawWidth, drawHeight;
                      if (imageAspectRatio > screenAspectRatio) {
                        drawWidth = constraints.maxWidth;
                        drawHeight = drawWidth / imageAspectRatio;
                      } else {
                        drawHeight = constraints.maxHeight;
                        drawWidth = drawHeight * imageAspectRatio;
                      }

                      return InteractiveViewer(
                        maxScale: 7.0,
                        minScale: 0.5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(
                              controller.selectedImage.value!,
                              width: drawWidth,
                              height: drawHeight,
                              fit: BoxFit.fill,
                            ),
                            if (controller.isLoading.value)
                              Container(
                                width: drawWidth,
                                height: drawHeight,
                                color: Colors.black26,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (!controller.isLoading.value &&
                                controller.detections.isNotEmpty)
                              SizedBox(
                                width: drawWidth,
                                height: drawHeight,
                                child: CustomPaint(
                                  painter: DetectionPainter(
                                    detections: controller.detections,
                                    imageSize: imageSize,
                                    type: type,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              if (type == DeteksiType.caries &&
                  controller.detections.value.isNotEmpty)
                Container(
                  color: TColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: const Text('Terindikasi Karies'),
                ),
              Obx(() => _buildResultSummary()),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultSummary() {
    if (controller.detections.isEmpty || controller.isLoading.value) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hasil Deteksi (${controller.detections.length})",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 35,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.detections.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final det = controller.detections[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: det.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: det.color, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "${det.groupName != null ? '${det.groupName}: ' : ''}${det.className}",
                      style: TextStyle(
                        color: det.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                bool picked = await controller.pickImageOnly(
                  ImageSource.gallery,
                );
                if (picked) controller.runDetection(type);
              },
              icon: const Icon(Icons.photo_library, size: 20),
              label: const Text("Gallery"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: TColors.primaryColor),
                foregroundColor: TColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                bool picked = await controller.pickImageOnly(
                  ImageSource.camera,
                );
                if (picked) controller.runDetection(type);
              },
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text("Camera"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: TColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter tidak diubah secara logika, hanya dipertahankan optimisasinya
class DetectionPainter extends CustomPainter {
  final List<DetectionResult> detections;
  final Size imageSize;
  final DeteksiType type;

  DetectionPainter({
    required this.detections,
    required this.imageSize,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    for (var det in detections) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = det.color;

      final rect = Rect.fromLTRB(
        det.box.left * scaleX,
        det.box.top * scaleY,
        det.box.right * scaleX,
        det.box.bottom * scaleY,
      );

      canvas.drawRect(rect, paint);

      if (type == DeteksiType.numbering) {
        if (det.groupName != null) {
          final groupSpan = TextSpan(
            text: det.groupName!.substring(0, 4),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 6,
            ),
          );
          final groupPainter = TextPainter(
            text: groupSpan,
            textDirection: TextDirection.ltr,
          )..layout();

          final groupBgRect = Rect.fromLTWH(
            rect.left,
            rect.top - groupPainter.height - 2,
            groupPainter.width + 4,
            groupPainter.height + 2,
          );
          canvas.drawRect(groupBgRect, Paint()..color = det.color);
          groupPainter.paint(
            canvas,
            Offset(rect.left + 2, groupBgRect.top + 1),
          );
        }

        final numSpan = TextSpan(
          text: det.className,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            fontSize: 6,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        );
        final numPainter = TextPainter(
          text: numSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final numOffset = Offset(
          rect.left + (rect.width - numPainter.width) / 2,
          rect.top + (rect.height - numPainter.height) / 2,
        );
        numPainter.paint(canvas, numOffset);
      } else {
        String labelText = "${det.className} ${det.score.toStringAsFixed(2)}";
        final textSpan = TextSpan(
          text: labelText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 7,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final labelBgRect = Rect.fromLTWH(
          rect.left,
          rect.top - textPainter.height - 1,
          textPainter.width + 3,
          textPainter.height + 1,
        );
        canvas.drawRect(labelBgRect, Paint()..color = det.color);
        textPainter.paint(
          canvas,
          Offset(rect.left + 1.5, rect.top - textPainter.height - 0.5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) => true;
}
