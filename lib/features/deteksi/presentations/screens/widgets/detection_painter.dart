import 'package:flutter/material.dart';

import '../../../core/deteksi_type.dart';
import '../../../data/models/detection_result.dart';

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
        ..strokeWidth = 1.4
        ..color = det.color;

      final rect = Rect.fromLTRB(
        det.box.left * scaleX,
        det.box.top * scaleY,
        det.box.right * scaleX,
        det.box.bottom * scaleY,
      );

      canvas.drawRect(rect, paint);

      if (type == DeteksiType.numbering) {
        final numSpan = TextSpan(
          text: det.className,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 8,
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
            fontSize: 4,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final labelBgRect = Rect.fromLTWH(
          rect.left,
          rect.top - textPainter.height - 2,
          textPainter.width + 4,
          textPainter.height + 2,
        );
        canvas.drawRect(labelBgRect, Paint()..color = det.color);
        textPainter.paint(
          canvas,
          Offset(rect.left + 2, rect.top - textPainter.height - 1),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) => true;
}