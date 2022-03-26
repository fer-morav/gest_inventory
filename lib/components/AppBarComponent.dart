import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AppBarComponent extends AppBar {

  AppBarComponent({
    required String textAppBar,
    required Function() onPressed,
    bool? isBack,
    Color? appBarColor,
    Color? textColor,
    double? textSize,
  }) : super(
    elevation: 0,
    title: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          textAppBar,
          style: TextStyle(
            color: textColor ?? primaryOnColor,
            fontWeight: FontWeight.w900,
            fontSize: 25,
          ),
        ),
      ),
    ),
    backgroundColor:  appBarColor,
    leading:const Icon(Icons.arrow_back_sharp) ,
  );
}