import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';

class Collector {
  String? id;
  String userId;
  String idNumber; // SA ID number
  String? idDocumentUrl;
  String? proofOfAddressUrl;
  String vehicleType; // "bicycle", "cart", "bakkie", "truck"
  String? vehicleRegistration;
  String? vehicleImageUrl;
  List<String> operatingAreas; // Suburbs/towns
  CollectorStatus status;
  DateTime applicationDate;
  DateTime? approvalDate;
  double rating;
  int totalPickups;
  double totalEarnings;
  List<String> certifications;
  String? bankAccountNumber;
  String? bankName;
  String? bankBranchCode;
  Map<String, dynamic> stats;
  bool isOnline;
  GeoPoint? lastLocation;

  Collector({
    this.id,
    required this.userId,
    required this.idNumber,
    required this.vehicleType,
    required this.operatingAreas,
    required this.status,
    required this.applicationDate,
    this.idDocumentUrl,
    this.proofOfAddressUrl,
    this.vehicleRegistration,
    this.vehicleImageUrl,
    this.approvalDate,
    this.rating = 0.0,
    this.totalPickups = 0,
    this.totalEarnings = 0.0,
    this.certifications = const [],
    this.bankAccountNumber,
    this.bankName,
    this.bankBranchCode,
    this.stats = const {},
    this.isOnline = false,
    this.lastLocation,
  });

  // Factory constructor to create Collector from Firestore Document
  factory Collector.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Collector(
      id: doc.id,
      userId: data['userId'] ?? '',
      idNumber: data['idNumber'] ?? '',
      idDocumentUrl: data['idDocumentUrl'],
      proofOfAddressUrl: data['proofOfAddressUrl'],
      vehicleType: data['vehicleType'] ?? 'bicycle',
      vehicleRegistration: data['vehicleRegistration'],
      vehicleImageUrl: data['vehicleImageUrl'],
      operatingAreas: List<String>.from(data['operatingAreas'] ?? []),
      status: CollectorStatus.values[data['status'] ?? 0],
      applicationDate: (data['applicationDate'] as Timestamp).toDate(),
      approvalDate: data['approvalDate'] != null 
          ? (data['approvalDate'] as Timestamp).toDate() 
          : null,
      rating: (data['rating'] ?? 0).toDouble(),
      totalPickups: data['totalPickups'] ?? 0,
      totalEarnings: (data['totalEarnings'] ?? 0).toDouble(),
      certifications: List<String>.from(data['certifications'] ?? []),
      bankAccountNumber: data['bankAccountNumber'],
      bankName: data['bankName'],
      bankBranchCode: data['bankBranchCode'],
      stats: Map<String, dynamic>.from(data['stats'] ?? {}),
      isOnline: data['isOnline'] ?? false,
      lastLocation: data['lastLocation'],
    );
  }

  // Convert Collector to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'idNumber': idNumber,
      'idDocumentUrl': idDocumentUrl,
      'proofOfAddressUrl': proofOfAddressUrl,
      'vehicleType': vehicleType,
      'vehicleRegistration': vehicleRegistration,
      'vehicleImageUrl': vehicleImageUrl,
      'operatingAreas': operatingAreas,
      'status': status.index,
      'applicationDate': Timestamp.fromDate(applicationDate),
      'approvalDate': approvalDate != null ? Timestamp.fromDate(approvalDate!) : null,
      'rating': rating,
      'totalPickups': totalPickups,
      'totalEarnings': totalEarnings,
      'certifications': certifications,
      'bankAccountNumber': bankAccountNumber,
      'bankName': bankName,
      'bankBranchCode': bankBranchCode,
      'stats': stats,
      'isOnline': isOnline,
      'lastLocation': lastLocation,
      'updatedAt': Timestamp.now(),
    };
  }

  // Helper methods
  String get statusText {
    switch (status) {
      case CollectorStatus.pending:
        return 'Application Pending';
      case CollectorStatus.approved:
        return 'Approved';
      case CollectorStatus.active:
        return 'Active';
      case CollectorStatus.suspended:
        return 'Suspended';
      case CollectorStatus.inactive:
        return 'Inactive';
    }
  }

  String get formattedEarnings => 'R${totalEarnings.toStringAsFixed(2)}';
  
  bool get canAcceptJobs => status == CollectorStatus.active;
  
  String get vehicleIcon {
    switch (vehicleType) {
      case 'bicycle':
        return '🚲';
      case 'cart':
        return '🛒';
      case 'bakkie':
        return '🚚';
      case 'truck':
        return '🚛';
      default:
        return '🚗';
    }
  }
}