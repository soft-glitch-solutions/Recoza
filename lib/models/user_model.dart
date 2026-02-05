import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { household, collector, unknown }

class AppUser {
  final String uid;
  final String? email;
  final String? name;
  final String? address;
  final UserRole role;
  final String? profilePictureUrl;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    this.email,
    this.name,
    this.address,
    this.role = UserRole.unknown,
    this.profilePictureUrl,
    this.createdAt,
  });

  // Factory constructor to create a User from a Firestore document
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] as String?,
      name: data['name'] as String?,
      address: data['address'] as String?,
      role: _parseUserRole(data['role'] as String?),
      profilePictureUrl: data['profilePictureUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert a User object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'address': address,
      'role': role.name,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Helper to parse the role from a string
  static UserRole _parseUserRole(String? role) {
    if (role == 'collector') return UserRole.collector;
    if (role == 'household') return UserRole.household;
    return UserRole.unknown;
  }
}
