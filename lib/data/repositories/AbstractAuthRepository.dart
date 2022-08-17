abstract class AbstractAuthRepository {
  String? getUserId();
  Future<bool> signOut();
  Stream<String?> get onAuthStateChanged;
  Future<String?> signInWithEmail(String email, String password);
  Future<String?> signUpWithEmail(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
}