import 'package:email_validator/email_validator.dart';

extension ValidStringExtensions on String {
  bool isEmailValid() => this.isNotEmpty && EmailValidator.validate(this);
  bool isPasswordValid() => this.isNotEmpty && this.length >= 6;
  bool isPhoneValid() => this.isNotEmpty && this.length == 10;
  bool isCPValid() => this.isNotEmpty && this.length == 5;
}

extension number on double {
  bool lowStocks() => this <= 5;
}