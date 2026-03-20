import 'package:flutter/material.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:toastification/toastification.dart';

import '../../features/deteksi/core/deteksi_type.dart';
import '../../features/deteksi/presentations/screens/widgets/detection_painter.dart';

class MyHelperFunction {
  // static Future<void> visitLink(Uri url) async {
  //   if (!await launchUrl(url)) {
  //     throw Exception('Tidak bisa membuka $url');
  //   }
  // }

  static void showToast(
    BuildContext context,
    String message,
    String description,
    ToastificationType? type,
  ) {
    final textTheme = Theme.of(context).textTheme;

    toastification.dismissAll();
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(
        message,
        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      description: Text(description, style: textTheme.bodySmall),
      alignment: Alignment.bottomRight,
      autoCloseDuration: const Duration(seconds: 5),
      icon: type == ToastificationType.success && type != null
          ? const Icon(Icons.check_circle)
          : const Icon(Icons.error),
    );
  }

  static void showFullScreenImage(
    BuildContext context,
    Size imageSize,
    DeteksiController controller,
    DeteksiType type,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 7.0,
              minScale: 0.5,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
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

                    return Stack(
                      children: [
                        Image.file(
                          controller.selectedImage.value!,
                          width: drawWidth,
                          height: drawHeight,
                          fit: BoxFit.fill,
                        ),
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
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
