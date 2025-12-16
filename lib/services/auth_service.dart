import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 📌 Current user
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 📝 Register with email + password
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1️⃣ Create auth account
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2️⃣ Add profile to Firestore
      await _db.collection("users").doc(cred.user!.uid).set({
        "name": name,
        "email": email,
        "height": 170,
        "weight": 70,
        "age": 20,
        "gender": "Not set",
        "isPremium": false,
        "createdAt": DateTime.now(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔐 Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
