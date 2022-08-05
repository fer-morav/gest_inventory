import 'package:email_validator/email_validator.dart';

extension ValidExtensions on String {
  bool isEmailValid() => this.isNotEmpty && EmailValidator.validate(this);
  bool isPasswordValid() => this.isNotEmpty && this.length >= 6;
}