import 'package:flutter/material.dart';
import 'colors.dart';

final light = ThemeData(
  primarySwatch: primaryColor as MaterialColor,
  primaryColor: primaryOnColor,
  iconTheme: IconThemeData(color: primaryOnColor),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
);
