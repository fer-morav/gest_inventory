import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

class BackButton extends StatelessWidget {
  final Function() onPressed;

  const BackButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: FloatingActionButton(
        child: Container(
          child: Transform.scale(
            scale: 1.5,
            child: Icon(Icons.arrow_back, color: Colors.white),
            alignment: Alignment.center,
          ),
        ),
        onPressed: onPressed,
        backgroundColor: primaryColor,
        elevation: 7,
      ),
    );
  }

}