import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/collector.dart';

class CollectorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Apply as collector
  Future<Collector?> applyAsCollector({
    required String userId,
    required String idNumber,
    required String vehicleType,
    required List<String> operatingAreas,
    String? idDocumentUrl,
    String? proofOfAddressUrl,
    String? vehicleRegistration,
    String? vehicleImageUrl,
  }) async {
    try {
      // Check if collector already exists
      final existingQuery = await _firestore
          .collection('collectors')
          .where('userId', isEqualTo: userId)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        throw Exception('You have already applied as a collector');
      }

      // Check if ID number already used
      final idCheck = await _firestore
          .collection('collectors')
          .where('idNumber', isEqualTo: idNumber)
          .get();

      if (idCheck.docs.isNotEmpty) {
        throw Exception('ID number already registered');
      }

      final collector = Collector(
        userId: userId,
        idNumber: idNumber,
        vehicleType: vehicleType,
        operatingAreas: operatingAreas,
        status: CollectorStatus.pending,
        applicationDate: DateTime.now(),
        idDocumentUrl: idDocumentUrl,
        proofOfAddressUrl: proofOfAddressUrl,
        vehicleRegistration: vehicleRegistration,
        vehicleImageUrl: vehicleImageUrl,
      );

      // Add to Firestore
      final docRef = await _firestore.collection('collectors').add(collector.toFirestore());
      collector.id = docRef.id;

      // Update user type
      await _firestore.collection('users').doc(userId).update({
        'userType': 1, // UserType.collector index
        'updatedAt': Timestamp.now(),
      });

      return collector;
    } catch (e) {
      print('Apply as collector error: $e');
      rethrow;
    }
  }

  // Get collector profile
  Future<Collector?> getCollectorProfile(String userId) async {
    try {
      final query = await _firestore
          .collection('collectors')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Collector.fromFirestore(query.docs.first);
      }
      return null;
    } catch (e) {
      print('Get collector profile error: $e');
      return null;
    }
  }

  // Stream collector profile
  Stream<Collector?> streamCollectorProfile(String userId) {
    return _firestore
        .collection('collectors')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return Collector.fromFirestore(snapshot.docs.first);
          }
          return null;
        });
  }

  // Update collector location
  Future<void> updateLocation(String collectorId, double lat, double lng) async {
    try {
      await _firestore.collection('collectors').doc(collectorId).update({
        'lastLocation': GeoPoint(lat, lng),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Update location error: $e');
    }
  }

  // Update collector online status
  Future<void> updateOnlineStatus(String collectorId, bool isOnline) async {
    try {
      await _firestore.collection('collectors').doc(collectorId).update({
        'isOnline': isOnline,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Update online status error: $e');
    }
  }

  // Get collector's assigned pickups
  Stream<List<PickupRequest>> getAssignedPickups(String collectorId) {
    return _firestore
        .collection('pickup_requests')
        .where('collectorId', isEqualTo: collectorId)
        .where('status', whereIn: [
          PickupStatus.scheduled.index,
          PickupStatus.inProgress.index,
        ])
        .orderBy('scheduledDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRequest.fromFirestore(doc))
            .toList());
  }

  // Get collector's completed pickups
  Stream<List<PickupRequest>> getCompletedPickups(String collectorId) {
    return _firestore
        .collection('pickup_requests')
        .where('collectorId', isEqualTo: collectorId)
        .where('status', isEqualTo: PickupStatus.completed.index)
        .orderBy('completedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRequest.fromFirestore(doc))
            .toList());
  }

  // Update collector earnings and stats
  Future<void> updateCollectorStats(String collectorId, double amount) async {
    try {
      await _firestore.collection('collectors').doc(collectorId).update({
        'totalEarnings': FieldValue.increment(amount),
        'totalPickups': FieldValue.increment(1),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Update collector stats error: $e');
    }
  }

  // Update bank details
  Future<bool> updateBankDetails({
    required String collectorId,
    required String accountNumber,
    required String bankName,
    required String branchCode,
  }) async {
    try {
      await _firestore.collection('collectors').doc(collectorId).update({
        'bankAccountNumber': accountNumber,
        'bankName': bankName,
        'bankBranchCode': branchCode,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Update bank details error: $e');
      return false;
    }
  }

  // Get collector ratings
  Future<void> updateRating(String collectorId, double rating) async {
    try {
      final doc = await _firestore.collection('collectors').doc(collectorId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final currentRating = data['rating'] ?? 0.0;
        final totalRatings = data['totalRatings'] ?? 0;
        
        final newTotalRatings = totalRatings + 1;
        final newRating = ((currentRating * totalRatings) + rating) / newTotalRatings;
        
        await _firestore.collection('collectors').doc(collectorId).update({
          'rating': newRating,
          'totalRatings': newTotalRatings,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Update rating error: $e');
    }
  }
}