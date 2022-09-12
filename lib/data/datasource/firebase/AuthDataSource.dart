import 'package:firebase_auth/firebase_auth.dart';
import 'package:gest_inventory/data/repositories/AbstractAuthRepository.dart';

class AuthDataSource extends AbstractAuthRepository {

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  String? getUserId() => _firebaseAuth.currentUser?.uid;

  @override
  String? getUserEmail() => _firebaseAuth.currentUser?.email;

  @override
  bool updateEmail(String newEmail) {
    try {
      _firebaseAuth.currentUser?.updateEmail(newEmail);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signOut() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
    }
    return true;
  }

  @override
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

  @override
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

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Stream<String?> get onAuthStateChanged => _firebaseAuth.authStateChanges().asyncMap((user) => user == null ? null : user.uid);

}
