import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';

class ButtonIcon extends StatelessWidget {
  final Function() onPressed;
  final bool isEnable;
  final AppIcons icon;
  final String text;
  final Color color;
  final sizeReference = 700.0;

  const ButtonIcon({
    Key? key,
    required this.onPressed,
    this.isEnable = true,
    required this.text,
    this.color = primaryColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return ElevatedButton.icon(
      icon: getIcon(icon, color: primaryOnColor),
      onPressed: isEnable ? onPressed : null,
      label: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: getResponsiveText(22),
          color: primaryOnColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: lightColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}