import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ui/components/FluttertoastDesing.dart';
import 'colors.dart';

class CustomToast {
  static void showToast({
    required String message,
    BuildContext? context,
    bool status = true,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    context == null
        ? Fluttertoast.showToast(
            msg: message,
            fontSize: 15,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: lightColor.withOpacity(0.2),
            textColor: blackColor,
            gravity: gravity,
            timeInSecForIosWeb: 3,
          )
        : FToast().init(context).showToast(
              child: FlutterToastDesign(
                status: status,
                message: message,
              ),
              gravity: gravity,
              toastDuration: Duration(
                seconds: 3,
              ),
            );
  }
}
