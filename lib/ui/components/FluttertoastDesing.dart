import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';

class FlutterToastDesign extends StatelessWidget {
  final bool status;
  final String message;

  const FlutterToastDesign({
    Key? key,
    required this.status,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: status ? okColor : errorColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          getIcon(
            status ? AppIcons.ok : AppIcons.error,
            color: primaryOnColor,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 15, color: primaryOnColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
