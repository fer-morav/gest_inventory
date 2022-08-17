import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/AbstractAuthRepository.dart';
import '../../../utils/strings.dart';

class AuthCubit extends Cubit<AuthState> {
  final AbstractAuthRepository _authRepository;
  late StreamSubscription _streamSubscription;

  AuthCubit(this._authRepository) : super(AuthInitialState());

  void init() {
    _streamSubscription = _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  Future<void> _authStateChanged(String? userId) async => userId == null
      ? emit(AuthSignedOut())
      : emit(AuthSignedIn(userId));

  Future<void> reset() async => emit(AuthInitialState());

  String? getUserId() => _authRepository.getUserId();

  Future<bool> signOut() async {
    final result = await _authRepository.signOut();
    emit(AuthSignedOut());
    return result;
  }

  Future<String?> signUpWithEmail(String email, String password) =>
      _signIn(_authRepository.signUpWithEmail(email, password));

  Future<String?> signInWithEmail(String email, String password) =>
      _signIn(_authRepository.signInWithEmail(email, password));

  Future<String?> _signIn(Future<String?> userId) async {
    try {
      emit(AuthSigningIn());
      final user = await userId;
      if (user == null) {
        emit(AuthError(alert_content_not_valid_data));
      } else {
        emit(AuthSignedIn(user));
      }
      return user;
    } catch (e) {
      emit(AuthError("Error ${e.toString()}"));
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final result = await _authRepository.sendPasswordResetEmail(email);
    emit(AuthSignedOut());
    return result;
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthSignedOut extends AuthState {}

class AuthSigningIn extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthSignedIn extends AuthState {
  final String? userId;

  AuthSignedIn(this.userId);
}
