import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/icons.dart';
import '../../utils/colors.dart';

class MainButton extends StatelessWidget {
  final Function() onPressed;
  final bool isEnable;
  final AppIcons? icon;
  final String text;
  final Color color;
  final sizeReference = 700.0;

  const MainButton({
    Key? key,
    required this.onPressed,
    this.isEnable = true,
    this.icon,
    required this.text,
    this.color = primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: getIcon(icon!, color: primaryOnColor),
                )
              : Container(),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getResponsiveText(22),
                color: primaryOnColor,
              ),
            ),
          ),
        ],
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
