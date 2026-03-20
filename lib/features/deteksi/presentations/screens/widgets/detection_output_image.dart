import 'package:flutter/material.dart';

import '../../../../../utils/helper_functions/helper.dart';
import '../../../core/deteksi_type.dart';
import '../../controllers/deteksi_controller.dart';
import 'detection_painter.dart';

class DetectionOutputImage extends StatelessWidget {
  const DetectionOutputImage({
    super.key,
    required this.imageSize,
    required this.controller,
    required this.type,
    required this.textTheme,
  });

  final Size imageSize;
  final DeteksiController controller;
  final DeteksiType type;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double imageAspectRatio = imageSize.width / imageSize.height;
            double drawWidth = constraints.maxWidth;
            double drawHeight = drawWidth / imageAspectRatio;

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    controller.selectedImage.value!,
                    width: drawWidth,
                    height: drawHeight,
                    fit: BoxFit.fill,
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
            );
          },
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => MyHelperFunction.showFullScreenImage(
              context,
              imageSize,
              controller,
              type,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text("Lihat Gambar", style: textTheme.labelMedium),
                  const SizedBox(width: 4),
                  const Icon(Icons.open_in_full, size: 14),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
