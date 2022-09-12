import 'package:flutter/material.dart';

class ProgressDialogComponent extends StatelessWidget {
  const ProgressDialogComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 170),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
