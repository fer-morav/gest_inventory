import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';
import 'icons.dart';

class CustomToast {
  static void showToast(
      {required String message, BuildContext? context, bool status = true}) {
    context == null
        ? Fluttertoast.showToast(
            msg: message,
            fontSize: 15,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: lightColor.withOpacity(0.2),
            textColor: blackColor,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          )
        : FToast().init(context).showToast(
              child: _getDesign(status, message),
              gravity: ToastGravity.BOTTOM,
              toastDuration: Duration(seconds: 2),
            );
  }

  static Widget _getDesign(bool status, String message) {
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
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
