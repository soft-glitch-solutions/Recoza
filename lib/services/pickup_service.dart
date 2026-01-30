import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/pickup_request.dart';
import '../constants/enums.dart';

class PickupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create new pickup request
  Future<PickupRequest> createPickupRequest({
    required String residentId,
    required String address,
    required double latitude,
    required double longitude,
    required Map<WasteType, double> wasteItems,
    required String instructions,
    required DateTime scheduledDate,
  }) async {
    try {
      // Convert waste items to map
      final wasteItemsMap = <String, double>{};
      wasteItems.forEach((key, value) {
        wasteItemsMap[key.index.toString()] = value;
      });

      // Calculate totals
      final totalWeight = wasteItems.values.fold(0.0, (sum, weight) => sum + weight);
      final paymentAmount = _calculatePayment(totalWeight, wasteItems);

      final pickup = PickupRequest(
        residentId: residentId,
        address: address,
        location: GeoPoint(latitude, longitude),
        wasteItems: wasteItemsMap,
        instructions: instructions,
        status: PickupStatus.pending,
        requestedDate: DateTime.now(),
        scheduledDate: scheduledDate,
        totalWeight: totalWeight,
        paymentAmount: paymentAmount,
        paymentStatus: 'pending',
      );

      // Add to Firestore
      final docRef = await _firestore.collection('pickup_requests').add(pickup.toFirestore());
      pickup.id = docRef.id;

      // Also add to user's pickup history
      await _firestore.collection('users').doc(residentId).collection('pickups').doc(docRef.id).set({
        'pickupId': docRef.id,
        'createdAt': Timestamp.now(),
      });

      return pickup;
    } catch (e) {
      print('Create pickup error: $e');
      rethrow;
    }
  }

  // Get user's pickup requests
  Stream<List<PickupRequest>> getUserPickups(String userId) {
    return _firestore
        .collection('pickup_requests')
        .where('residentId', isEqualTo: userId)
        .orderBy('scheduledDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRequest.fromFirestore(doc))
            .toList());
  }

  // Get available pickups for collectors
  Stream<List<PickupRequest>> getAvailablePickups({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) {
    // Note: Firestore doesn't support native geo queries without extensions
    // For production, use GeoFirestore or similar
    
    return _firestore
        .collection('pickup_requests')
        .where('status', isEqualTo: PickupStatus.pending.index)
        .where('scheduledDate', isGreaterThanOrEqualTo: Timestamp.now())
        .snapshots()
        .map((snapshot) {
          // Filter by distance (client-side for now)
          return snapshot.docs
              .map((doc) => PickupRequest.fromFirestore(doc))
              .where((pickup) {
                final distance = Geolocator.distanceBetween(
                  latitude,
                  longitude,
                  pickup.location.latitude,
                  pickup.location.longitude,
                ) / 1000; // Convert to km
                return distance <= radiusKm;
              })
              .toList();
        });
  }

  // Get pickup by ID
  Future<PickupRequest?> getPickupById(String pickupId) async {
    try {
      final doc = await _firestore.collection('pickup_requests').doc(pickupId).get();
      if (doc.exists) {
        return PickupRequest.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Get pickup error: $e');
      return null;
    }
  }

  // Update pickup status
  Future<void> updatePickupStatus(String pickupId, PickupStatus status) async {
    try {
      await _firestore.collection('pickup_requests').doc(pickupId).update({
        'status': status.index,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Update pickup status error: $e');
      rethrow;
    }
  }

  // Assign collector to pickup
  Future<void> assignCollector(String pickupId, String collectorId) async {
    try {
      await _firestore.collection('pickup_requests').doc(pickupId).update({
        'collectorId': collectorId,
        'status': PickupStatus.scheduled.index,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Assign collector error: $e');
      rethrow;
    }
  }

  // Cancel pickup
  Future<bool> cancelPickup(String pickupId, String reason) async {
    try {
      await _firestore.collection('pickup_requests').doc(pickupId).update({
        'status': PickupStatus.cancelled.index,
        'cancellationReason': reason,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Cancel pickup error: $e');
      return false;
    }
  }

  // Complete pickup
  Future<bool> completePickup(String pickupId, String imageUrl, String notes) async {
    try {
      await _firestore.collection('pickup_requests').doc(pickupId).update({
        'status': PickupStatus.completed.index,
        'completedDate': Timestamp.now(),
        'proofImageUrl': imageUrl,
        'collectorNotes': notes,
        'paymentStatus': 'paid',
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Complete pickup error: $e');
      return false;
    }
  }

  // Collector applies for pickup
  Future<bool> applyForPickup(String pickupId, String collectorId) async {
    try {
      await _firestore.collection('pickup_requests').doc(pickupId).update({
        'collectorApplications': FieldValue.arrayUnion([collectorId]),
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Apply for pickup error: $e');
      return false;
    }
  }

  // Payment calculation
  double _calculatePayment(double totalWeight, Map<WasteType, double> wasteItems) {
    double baseRate = 8.0; // R8 per kg base rate
    double total = totalWeight * baseRate;
    
    // Premium for certain types
    if (wasteItems.containsKey(WasteType.ewaste)) {
      total += wasteItems[WasteType.ewaste]! * 5.0; // Extra R5/kg for e-waste
    }
    
    return total;
  }
}