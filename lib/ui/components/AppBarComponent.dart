import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';

class AppBarComponent extends AppBar {
  AppBarComponent({
    required String textAppBar,
    required Function() onPressed,
    IconButton? action,
  }) : super(
          elevation: 0,
          backgroundColor: primaryColor,
          title: FittedBox(
            child: Align(
              child: Text(
                textAppBar,
                style: TextStyle(
                  color: primaryOnColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          leading: IconButton(
            onPressed: onPressed,
            icon: getIcon(
              AppIcons.arrow_back,
              size: 30,
            ),
          ),
          actions: [
            action ?? Container(),
          ],
        );
}
