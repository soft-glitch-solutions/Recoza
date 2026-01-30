import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';

class User {
  String? id;
  String email;
  String fullName;
  String phoneNumber;
  UserType userType;
  DateTime createdAt;
  bool isVerified;
  String? profileImageUrl;
  List<String> savedAddresses;
  Map<String, dynamic> preferences;

  User({
    this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    required this.createdAt,
    this.isVerified = false,
    this.profileImageUrl,
    this.savedAddresses = const [],
    this.preferences = const {},
  });

  // Factory constructor to create User from Firestore Document
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      userType: UserType.values[data['userType'] ?? 0],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      profileImageUrl: data['profileImageUrl'],
      savedAddresses: List<String>.from(data['savedAddresses'] ?? []),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  // Convert User to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'userType': userType.index,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'profileImageUrl': profileImageUrl,
      'savedAddresses': savedAddresses,
      'preferences': preferences,
      'updatedAt': Timestamp.now(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    UserType? userType,
    DateTime? createdAt,
    bool? isVerified,
    String? profileImageUrl,
    List<String>? savedAddresses,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      preferences: preferences ?? this.preferences,
    );
  }

  // Helper method to get display name
  String get displayName => fullName.split(' ').first;

  // Check if user is collector
  bool get isCollector => userType == UserType.collector;
}