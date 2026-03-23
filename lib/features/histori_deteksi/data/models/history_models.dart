import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModels {
  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final int jumlahTerdeteksi;
  final String type;

  HistoryModels({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.jumlahTerdeteksi,
    required this.type,
  });

  factory HistoryModels.fromMap(Map<String, dynamic> map, String documentId) {
    return HistoryModels(
      id: documentId,
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate() ?? DateTime.now(),
      jumlahTerdeteksi: map['resultCount'] ?? 0,
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'resultCount': jumlahTerdeteksi,
      'type': type,
    };
  }
}
