import 'package:email_validator/email_validator.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension ValidStringExtensions on String {
  bool isEmailValid() => this.isNotEmpty && EmailValidator.validate(this);

  bool isPasswordValid() => this.isNotEmpty && this.length >= 6;

  bool isPhoneValid() => this.isNotEmpty && this.length == 10;

  bool isCPValid() => this.isNotEmpty && this.length == 5;
}

extension numberExtensions on double {
  bool lowStocks() => this <= 5;
}

extension DateTimeExtensions on DateTime {
  bool inMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
            .difference(DateTime(
              year,
              month,
              day,
              hour,
              minute,
              second,
            )).inDays <= 30;
  }

  bool inWeek() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
            .difference(DateTime(
              year,
              month,
              day,
              hour,
              minute,
              second,
            )).inDays <= 7;
  }

  bool isToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
            .difference(DateTime(
              year,
              month,
              day,
              hour,
              minute,
              second,
            )).inDays == 0;
  }

  bool isYesterday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second)
            .difference(DateTime(
              year,
              month,
              day,
              hour,
              minute,
              second,
            )).inDays == 1;
  }

  bool compareDates(DateTime otherDate) {
    return DateTime(
          otherDate.year,
          otherDate.month,
          otherDate.day,
          otherDate.hour,
          otherDate.minute,
          otherDate.second,
        ).difference(
              DateTime(
                year,
                month,
                day,
                hour,
                minute,
                second,
              ),
            ).inDays == 0;
  }

  String toFormatDate() {
    initializeDateFormatting('es');
    return this.isToday()
        ? button_today
        : this.isYesterday()
            ? button_yesterday
            : DateFormat.yMMMMEEEEd('es').format(this);
  }

  String toFormatHour() => DateFormat('hh:mm a').format(this);
}
