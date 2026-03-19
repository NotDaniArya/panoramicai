import 'dart:ui';

class DetectionResult {
  final Rect box;
  final double score;
  final int classId;
  final String className;
  final String? groupName;
  final Color color;

  DetectionResult({
    required this.box,
    required this.score,
    required this.classId,
    required this.className,
    this.groupName,
    required this.color,
  });
}
