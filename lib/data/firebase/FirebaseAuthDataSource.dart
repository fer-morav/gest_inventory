import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final _firebaseAuth = FirebaseAuth.instance;

  String? getUserId() {
    final _user = _firebaseAuth.currentUser;
    return _user?.uid;
  }

  Future<bool> signOut() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
    }
    return true;
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;

      return user?.uid;
    } catch (error) {
      return null;
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;

      return user?.uid;
    } catch (error) {
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      return false;
    }
  }
}
