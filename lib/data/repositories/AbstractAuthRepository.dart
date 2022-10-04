abstract class AbstractAuthRepository {
  String? getUserId();
  String? getUserEmail();
  bool updateEmail(String newEmail);
  Future<bool> signOut();
  Stream<String?> get onAuthStateChanged;
  Future<String?> signInWithEmail(String email, String password);
  Future<String?> signUpWithEmail(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
}