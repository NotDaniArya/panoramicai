import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/features/deteksi/core/deteksi_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panoramicai/features/deteksi/data/models/detection_result.dart';
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
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Padding diperkecil agar gambar lebih besar
                  child: controller.selectedImage.value == null
                      ? const Text("Tidak ada gambar yang dipilih")
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return FutureBuilder<Size>(
                              future: _getImageSize(controller.selectedImage.value!),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final imageSize = snapshot.data!;
                                final double screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                                final double imageAspectRatio = imageSize.width / imageSize.height;

                                double drawWidth, drawHeight;
                                if (imageAspectRatio > screenAspectRatio) {
                                  drawWidth = constraints.maxWidth;
                                  drawHeight = drawWidth / imageAspectRatio;
                                } else {
                                  drawHeight = constraints.maxHeight;
                                  drawWidth = drawHeight * imageAspectRatio;
                                }

                                return InteractiveViewer(
                                  maxScale: 7.0, // Zoom ditingkatkan hingga 10x
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
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                      if (!controller.isLoading.value && controller.detections.isNotEmpty)
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
                          },
                        ),
                ),
              ),
            ),
            _buildResultSummary(),
            _buildActionButtons(context),
          ],
        );
      }),
    );
  }

  Future<Size> _getImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return Size(image.width.toDouble(), image.height.toDouble());
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: det.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: det.color, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      "${det.groupName != null ? '${det.groupName}: ' : ''}${det.className}",
                      style: TextStyle(color: det.color, fontWeight: FontWeight.bold, fontSize: 11),
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
              onPressed: () => controller.pickImage(ImageSource.gallery, type),
              icon: const Icon(Icons.photo_library, size: 20),
              label: const Text("Gallery"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: TColors.primaryColor),
                foregroundColor: TColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.pickImage(ImageSource.camera, type),
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text("Camera"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: TColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetectionPainter extends CustomPainter {
  final List<DetectionResult> detections;
  final Size imageSize;
  final DeteksiType type;

  DetectionPainter({required this.detections, required this.imageSize, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    for (var det in detections) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 // Garis halus
        ..color = det.color;

      final rect = Rect.fromLTRB(
        det.box.left * scaleX,
        det.box.top * scaleY,
        det.box.right * scaleX,
        det.box.bottom * scaleY,
      );

      // 1. Gambar Kotak Deteksi
      canvas.drawRect(rect, paint);

      if (type == DeteksiType.numbering) {
        // --- KHUSUS NUMBERING ---

        // 2. Gambar Label Group (Permanent/Sulung) di ATAS kotak
        if (det.groupName != null) {
          final groupSpan = TextSpan(
            text: det.groupName!.substring(0, 4),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 6, // Ukuran kecil untuk label group
            ),
          );
          final groupPainter = TextPainter(text: groupSpan, textDirection: TextDirection.ltr);
          groupPainter.layout();

          final groupBgRect = Rect.fromLTWH(
            rect.left,
            rect.top - groupPainter.height - 2,
            groupPainter.width + 4,
            groupPainter.height + 2,
          );

          canvas.drawRect(groupBgRect, Paint()..color = det.color);
          groupPainter.paint(canvas, Offset(rect.left + 2, groupBgRect.top + 1));
        }

        // 3. Gambar Nomor Gigi di TENGAH kotak
        final numSpan = TextSpan(
          text: det.className,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            fontSize: 6,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        );
        final numPainter = TextPainter(text: numSpan, textDirection: TextDirection.ltr);
        numPainter.layout();

        final numOffset = Offset(
          rect.left + (rect.width - numPainter.width) / 2,
          rect.top + (rect.height - numPainter.height) / 2,
        );
        numPainter.paint(canvas, numOffset);

      } else {
        // --- KHUSUS CARIES ---
        String labelText = "${det.className} ${det.score.toStringAsFixed(2)}";
        final textSpan = TextSpan(
          text: labelText,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 7),
        );
        final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
        textPainter.layout();

        final labelBgRect = Rect.fromLTWH(
          rect.left,
          rect.top - textPainter.height - 1,
          textPainter.width + 3,
          textPainter.height + 1,
        );

        canvas.drawRect(labelBgRect, Paint()..color = det.color);
        textPainter.paint(canvas, Offset(rect.left + 1.5, rect.top - textPainter.height - 0.5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
