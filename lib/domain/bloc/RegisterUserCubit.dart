import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../utils/strings.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  RegisterUserCubit() : super(RegisterUserState());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? emailValidator(String? value) => value!.isEmpty
      ? textfield_error_email_empty
      : value.isEmailValid()
          ? null
          : textfield_error_email;

  String? passwordValidator(String? value) => value!.isEmpty
      ? textfield_error_password_empty
      : value.isPasswordValid()
          ? null
          : textfield_error_password;

  String? confirmValidator(String? confirmPassword, String password) =>
      password == confirmPassword ? null : textfield_error_confirm_password;

  void showPassword() => _newState(showPassword: !state.showPassword);

  void showConfirmPassword() =>
      _newState(showConfirmPassword: !state.showConfirmPassword);

  void setLoading(bool value) => _newState(loading: value);

  void _newState({
    bool? showPassword,
    bool? showConfirmPassword,
    bool? loading,
  }) {
    emit(RegisterUserState(
      showPassword: showPassword ?? state.showPassword,
      showConfirmPassword: showConfirmPassword ?? state.showConfirmPassword,
      loading: loading ?? state.loading,
    ));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

class RegisterUserState {
  final bool showPassword;
  final bool showConfirmPassword;
  final bool loading;

  RegisterUserState({
    this.showPassword = true,
    this.showConfirmPassword = true,
    this.loading = false,
  });
}