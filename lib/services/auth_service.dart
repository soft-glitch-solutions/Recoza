import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import '../constants/enums.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      userType: UserType.resident, // Default
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      isVerified: user.emailVerified,
    ) : null;
  }

  // Stream of user
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebase);
  }

  // Email & Password Sign In
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return _userFromFirebase(credential.user);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Email & Password Registration
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    UserType userType = UserType.resident,
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        userType: userType,
        createdAt: DateTime.now(),
        isVerified: false,
      );

      await _firestore.collection('users').doc(user.id).set(user.toFirestore());

      // Update display name
      await credential.user!.updateDisplayName(fullName);

      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Google Sign In
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Check if user exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      
      if (!userDoc.exists) {
        // Create new user in Firestore
        final newUser = UserModel(
          id: user.uid,
          email: user.email ?? '',
          fullName: user.displayName ?? googleUser.displayName ?? '',
          phoneNumber: user.phoneNumber ?? '',
          userType: UserType.resident,
          createdAt: DateTime.now(),
          isVerified: true,
          profileImageUrl: user.photoURL ?? googleUser.photoUrl,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());
        return newUser;
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      print('Google sign in error: $e');
      return null;
    }
  }

  // Phone Number Sign In (SA context)
  Future<bool> verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+27${phoneNumber.substring(1)}', // Add SA country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store verificationId for later use
          // You'll need to implement SMS code input
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
      return true;
    } catch (e) {
      print('Phone verification error: $e');
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['fullName'] = fullName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      updateData['updatedAt'] = Timestamp.now();

      await _firestore.collection('users').doc(userId).update(updateData);
      
      // Also update Firebase Auth display name
      if (fullName != null) {
        await _auth.currentUser?.updateDisplayName(fullName);
      }

      return true;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('Check email error: $e');
      return false;
    }
  }
}