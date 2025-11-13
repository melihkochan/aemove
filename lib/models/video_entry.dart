import 'package:cloud_firestore/cloud_firestore.dart';

enum VideoStatus {
  processing,
  completed,
  failed,
}

class VideoEntry {
  final String id;
  final String title;
  final String? description;
  final String? modelName;
  final String? thumbnailUrl;
  final Duration? duration;
  final DateTime? createdAt;
  final VideoStatus status;

  const VideoEntry({
    required this.id,
    required this.title,
    required this.status,
    this.description,
    this.modelName,
    this.thumbnailUrl,
    this.duration,
    this.createdAt,
  });

  factory VideoEntry.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return VideoEntry(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled video',
      description: data['description'] as String?,
      modelName: data['modelName'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      duration: data['durationSeconds'] != null
          ? Duration(seconds: (data['durationSeconds'] as num).toInt())
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      status: _parseStatus(data['status'] as String?),
    );
  }

  static VideoStatus _parseStatus(String? status) {
    switch (status) {
      case 'completed':
        return VideoStatus.completed;
      case 'failed':
        return VideoStatus.failed;
      case 'processing':
      default:
        return VideoStatus.processing;
    }
  }
}

