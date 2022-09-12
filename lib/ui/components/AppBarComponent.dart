import 'package:flutter/material.dart';
import 'package:gest_inventory/ui/components/BackButton.dart';
import '../../utils/colors.dart';

class AppBarComponent extends AppBar {
  AppBarComponent({
    required String textAppBar,
    required Function() onPressed,
    IconButton? action,
  }) : super(
          elevation: 0,
          toolbarHeight: 80,
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
          leading: Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 5, top: 15),
              child: BackButtonBar(
                onPressed: onPressed,
                color: primaryOnColor,
              ),
            ),
          ),
          actions: [
            action ?? Container(),
          ],
        );
}
