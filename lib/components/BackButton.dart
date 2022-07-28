import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

import '../utils/icons.dart';

class BackButton extends StatelessWidget {
  final Function() onPressed;

  const BackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FloatingActionButton(
        isExtended: true,
        child: Container(
          child: getIcon(
            AppIcons.arrow_back,
            color: lightColor,
            size: 30,
          ),
        ),
        onPressed: onPressed,
        backgroundColor: primaryColor,
        elevation: 7,
      ),
    );
  }
}
