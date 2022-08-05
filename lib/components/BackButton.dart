import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

import '../utils/icons.dart';

class BackButtonBar extends StatelessWidget {
  final Function() onPressed;
  final Color? color;

  const BackButtonBar({
    Key? key,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Container(
        child: Transform.scale(
          scale: 1.5,
          child: getIcon(
            AppIcons.arrow_back,
            color: color == null ? primaryOnColor : color,
          ),
        ),
      ),
      onPressed: onPressed,
      backgroundColor: color == null ? primaryColor : primaryOnColor,
    );
  }
}
