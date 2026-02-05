import 'package:cloud_firestore/cloud_firestore.dart';

enum PickupStatus { pending, confirmed, completed, cancelled }

class PickupRequest {
  final String id;
  final String userId;
  final String? collectorId;
  final List<String> materials;
  final GeoPoint location;
  final PickupStatus status;
  final DateTime scheduledAt;
  final DateTime? completedAt;

  PickupRequest({
    required this.id,
    required this.userId,
    this.collectorId,
    required this.materials,
    required this.location,
    this.status = PickupStatus.pending,
    required this.scheduledAt,
    this.completedAt,
  });

  factory PickupRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PickupRequest(
      id: doc.id,
      userId: data['userId'] as String,
      collectorId: data['collectorId'] as String?,
      materials: List<String>.from(data['materials'] as List),
      location: data['location'] as GeoPoint,
      status: _parseStatus(data['status'] as String?),
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'collectorId': collectorId,
      'materials': materials,
      'location': location,
      'status': status.name,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  static PickupStatus _parseStatus(String? status) {
    switch (status) {
      case 'confirmed':
        return PickupStatus.confirmed;
      case 'completed':
        return PickupStatus.completed;
      case 'cancelled':
        return PickupStatus.cancelled;
      default:
        return PickupStatus.pending;
    }
  }
}
