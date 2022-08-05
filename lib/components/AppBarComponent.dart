import 'package:flutter/material.dart';
import 'package:gest_inventory/components/BackButton.dart';
import '../utils/colors.dart';

class AppBarComponent extends AppBar {
  AppBarComponent({
    required String textAppBar,
    Function()? onPressed,
    Color? appBarColor,
    Color? textColor,
    double? textSize,
    FloatingActionButton? action,
  }) : super(
          elevation: 0,
          toolbarHeight: 80,
          title: FittedBox(
            child: Align(
              child: Text(
                textAppBar,
                style: TextStyle(
                  color: textColor ?? primaryOnColor,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          backgroundColor: appBarColor,
          leading: onPressed != null
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: BackButtonBar(
                      onPressed: onPressed,
                    ),
                  ),
                )
              : null,
          actions: <Widget>[
            action != null ? action : Container(),
          ],
        );
}
