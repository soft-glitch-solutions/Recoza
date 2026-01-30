import 'pickup_request.dart';

class Job {
  final PickupRequest pickupRequest;
  final double distance; // in km
  final double estimatedEarnings;
  final DateTime postedTime;
  final int? applicantsCount;
  final bool isApplied;
  final bool isAccepted;

  Job({
    required this.pickupRequest,
    required this.distance,
    required this.estimatedEarnings,
    required this.postedTime,
    this.applicantsCount,
    this.isApplied = false,
    this.isAccepted = false,
  });

  String get formattedDistance => '${distance.toStringAsFixed(1)} km';
  
  String get formattedEarnings => 'R${estimatedEarnings.toStringAsFixed(2)}';
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(postedTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  bool get isUrgent => postedTime.isAfter(DateTime.now().subtract(const Duration(hours: 1)));
}