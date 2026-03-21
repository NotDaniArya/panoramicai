import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panoramicai/features/deteksi/presentations/controllers/deteksi_controller.dart';
import 'package:panoramicai/utils/constant/texts.dart';
import 'package:panoramicai/utils/constant/texts.dart';
import 'package:panoramicai/utils/constant/texts.dart';
import 'package:toastification/toastification.dart';

import '../../features/deteksi/core/deteksi_type.dart';
import '../../features/deteksi/presentations/screens/widgets/detection_painter.dart';

class MyHelperFunction {
  // static Future<void> visitLink(Uri url) async {
  //   if (!await launchUrl(url)) {
  //     throw Exception('Tidak bisa membuka $url');
  //   }
  // }

  static warningToast(String message) {
    Get.snackbar(TTexts.tag_warning, '😢 $message',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.teal,
        icon: const Icon(
          Icons.warning_amber,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.bounceInOut);
  }

  static suksesToast(String message) {
    Get.snackbar(TTexts.tag_sukses, '😊 $message',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.thumb_up_off_alt,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.bounceInOut);
  }

  static errorToast(String message) {
    Get.snackbar(TTexts.tag_error, '🥹 $message',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 4),
        forwardAnimationCurve: Curves.bounceInOut);
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
