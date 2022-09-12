import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/icons.dart';

import '../../utils/colors.dart';

class IconButtonComponent extends StatelessWidget {
  final Function() onPressed;
  final AppIcons icon;
  final String text;

  const IconButtonComponent({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [primaryDark, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.5, 0.6],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getIcon(
              icon,
              color: primaryOnColor,
              size: 50,
            ),
            SizedBox(height: 15),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: primaryOnColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
