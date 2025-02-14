import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Sign up with email and password
  Future<User?> signUp(
      String email, String password, String name, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveCredentialsToFirestore(email, password, name, userName);
      return result.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Save user credentials to Firestore
  Future<void> saveCredentialsToFirestore(
    String email,
    String password,
    String name,
    String text,
  ) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'password': password,
          'name': name,
          'userName': text,
          'phone': 'N/A',
          'address': 'N/A',
          'bio': 'N/A',
          'profileImage': '',
        });
      }
    } catch (e) {
      print("Error saving credentials to Firestore: $e");
    }
  }

  // Log out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Delete user account
  Future<void> deleteUserAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String email = user.email!;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .delete();
        await user.delete();
        await _storage.deleteAll();
      }
    } catch (e) {
      print("Error deleting user account: $e");
    }
  }

  // Fetch user credentials from Firestore
  Future<Map<String, String>?> fetchCredentialsFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return {
            'email': doc['email'],
            'name': doc['name'],
            'userName': doc['userName'],
            'phone': doc['phone'] ?? 'N/A',
            'address': doc['address'] ?? 'N/A',
            'bio': doc['bio'] ?? 'N/A',
            'profileImage': doc['profileImage'] ?? '',
          };
        } else {
          print("No such document!");
          return null;
        }
      } else {
        print("No user is currently signed in!");
        return null;
      }
    } catch (e) {
      print("Error fetching credentials from Firestore: $e");
      return null;
    }
  }

  // Biometric authentication
  Future<bool> authenticateWithBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error with biometric auth: $e");
      return false;
    }
  }

  // Save user credentials securely
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  // Retrieve user credentials
  Future<Map<String, String?>> getCredentials() async {
    String? email = await _storage.read(key: 'email');
    String? password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  // Reset password method
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error resetting password: $e");
      rethrow;
    }
  }
}
