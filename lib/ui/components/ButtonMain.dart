import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

class ButtonMain extends StatelessWidget {
  final Function() onPressed;
  final bool isDisabled;
  final Widget? child;
  final String text;
  final sizeReference = 700.0;

  const ButtonMain({
    Key? key,
    required this.onPressed,
    this.child,
    required this.text,
    required this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: getResponsiveText(18),
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: primaryOnColor,
        side: const BorderSide(width: 2.0, color: primaryColor),
        backgroundColor: primaryOnColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
