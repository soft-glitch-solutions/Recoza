import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';

class PickupRequest {
  String? id;
  String residentId;
  String? collectorId;
  String address;
  GeoPoint location;
  Map<String, double> wasteItems; // wasteTypeIndex -> weight
  String instructions;
  PickupStatus status;
  DateTime requestedDate;
  DateTime scheduledDate;
  DateTime? completedDate;
  double totalWeight;
  double paymentAmount;
  String paymentStatus; // "pending", "paid", "failed"
  String? collectorNotes;
  String? residentNotes;
  String? proofImageUrl;
  String? cancellationReason;
  String? rejectionReason;
  List<String> collectorApplications; // IDs of collectors who applied

  PickupRequest({
    this.id,
    required this.residentId,
    required this.address,
    required this.location,
    required this.wasteItems,
    required this.instructions,
    required this.status,
    required this.requestedDate,
    required this.scheduledDate,
    this.collectorId,
    this.completedDate,
    required this.totalWeight,
    required this.paymentAmount,
    required this.paymentStatus,
    this.collectorNotes,
    this.residentNotes,
    this.proofImageUrl,
    this.cancellationReason,
    this.rejectionReason,
    this.collectorApplications = const [],
  });

  // Factory constructor to create PickupRequest from Firestore Document
  factory PickupRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Convert waste items
    final wasteItems = <String, double>{};
    if (data['wasteItems'] != null) {
      (data['wasteItems'] as Map<String, dynamic>).forEach((key, value) {
        wasteItems[key] = (value as num).toDouble();
      });
    }

    return PickupRequest(
      id: doc.id,
      residentId: data['residentId'] ?? '',
      collectorId: data['collectorId'],
      address: data['address'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      wasteItems: wasteItems,
      instructions: data['instructions'] ?? '',
      status: PickupStatus.values[data['status'] ?? 0],
      requestedDate: (data['requestedDate'] as Timestamp).toDate(),
      scheduledDate: (data['scheduledDate'] as Timestamp).toDate(),
      completedDate: data['completedDate'] != null 
          ? (data['completedDate'] as Timestamp).toDate() 
          : null,
      totalWeight: (data['totalWeight'] ?? 0).toDouble(),
      paymentAmount: (data['paymentAmount'] ?? 0).toDouble(),
      paymentStatus: data['paymentStatus'] ?? 'pending',
      collectorNotes: data['collectorNotes'],
      residentNotes: data['residentNotes'],
      proofImageUrl: data['proofImageUrl'],
      cancellationReason: data['cancellationReason'],
      rejectionReason: data['rejectionReason'],
      collectorApplications: List<String>.from(data['collectorApplications'] ?? []),
    );
  }

  // Convert PickupRequest to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'residentId': residentId,
      'collectorId': collectorId,
      'address': address,
      'location': location,
      'wasteItems': wasteItems,
      'instructions': instructions,
      'status': status.index,
      'requestedDate': Timestamp.fromDate(requestedDate),
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'totalWeight': totalWeight,
      'paymentAmount': paymentAmount,
      'paymentStatus': paymentStatus,
      'collectorNotes': collectorNotes,
      'residentNotes': residentNotes,
      'proofImageUrl': proofImageUrl,
      'cancellationReason': cancellationReason,
      'rejectionReason': rejectionReason,
      'collectorApplications': collectorApplications,
      'updatedAt': Timestamp.now(),
    };
  }

  // Helper methods
  String get statusText {
    switch (status) {
      case PickupStatus.pending:
        return 'Awaiting Collector';
      case PickupStatus.scheduled:
        return 'Scheduled';
      case PickupStatus.inProgress:
        return 'In Progress';
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get formattedAmount => 'R${paymentAmount.toStringAsFixed(2)}';
  
  String get formattedDate {
    final day = scheduledDate.day.toString().padLeft(2, '0');
    final month = scheduledDate.month.toString().padLeft(2, '0');
    final year = scheduledDate.year.toString();
    return '$day/$month/$year';
  }
  
  String get formattedTime {
    final hour = scheduledDate.hour.toString().padLeft(2, '0');
    final minute = scheduledDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  bool get isActive => status == PickupStatus.pending || 
                      status == PickupStatus.scheduled || 
                      status == PickupStatus.inProgress;
  
  bool get hasCollector => collectorId != null && collectorId!.isNotEmpty;
  
  // Calculate waste type breakdown
  Map<WasteType, double> get wasteTypeBreakdown {
    final breakdown = <WasteType, double>{};
    wasteItems.forEach((key, value) {
      final typeIndex = int.tryParse(key);
      if (typeIndex != null && typeIndex < WasteType.values.length) {
        breakdown[WasteType.values[typeIndex]] = value;
      }
    });
    return breakdown;
  }
}