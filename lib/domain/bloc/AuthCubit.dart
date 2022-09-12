import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/AbstractAuthRepository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AbstractAuthRepository _authRepository;
  late StreamSubscription _streamSubscription;

  AuthCubit(this._authRepository) : super(AuthState.signIn);

  void init() {
    _streamSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  void _authStateChanged(String? userId) =>
      userId == null ? emit(AuthState.signOut) : emit(AuthState.signedIn);

  void setState(AuthState newState) => emit(newState);

  String? getUserId() => _authRepository.getUserId();

  String? getUserEmail() => _authRepository.getUserEmail();

  bool updateEmail(String newEmail) => _authRepository.updateEmail(newEmail);

  Future<bool> signOut() async {
    final result = await _authRepository.signOut();
    result ? emit(AuthState.signOut) : emit(AuthState.error);
    return result;
  }

  Future<String?> signUpWithEmail(String email, String password) =>
      _signIn(_authRepository.signUpWithEmail(email, password));

  Future<String?> signInWithEmail(String email, String password) =>
      _signIn(_authRepository.signInWithEmail(email, password));

  Future<String?> _signIn(Future<String?> userId) async {
    try {
      emit(AuthState.signIn);
      final user = await userId;
      if (user == null) {
        emit(AuthState.error);
      } else {
        emit(AuthState.signedIn);
      }
      return user;
    } catch (e) {
      emit(AuthState.error);
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final result = await _authRepository.sendPasswordResetEmail(email);
    result ? emit(AuthState.signOut) : emit(AuthState.error);
    return result;
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

enum AuthState {
  signIn,
  signUp,
  signOut,
  signedIn,
  error,
}
