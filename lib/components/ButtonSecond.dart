import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

class ButtonSecond extends StatelessWidget {
  final Function() onPressed;
  final Widget? child;
  final String text;
  final sizeReference = 700.0;

  const ButtonSecond(
      {Key? key,
      required this.onPressed,
      this.child,
      required this.text,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      onPressed: onPressed,
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      elevation: 3,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: getResponsiveText(18), fontWeight: FontWeight.w800),
      ),
      isExtended: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
