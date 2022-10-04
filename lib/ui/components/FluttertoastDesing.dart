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
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: status ? okColor : errorColor,
      leading: getIcon(
        status ? AppIcons.ok : AppIcons.error,
        color: primaryOnColor,
      ),
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: primaryOnColor),
      ),
      trailing: getIcon(
        status ? AppIcons.ok : AppIcons.error,
        color: status ? okColor : errorColor,
      ),
    );
  }
}
