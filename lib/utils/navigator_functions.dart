import 'package:flutter/material.dart';

popAndPushNamedWithArgs(BuildContext context, String route, Map<String, dynamic> args) {
  Navigator.popAndPushNamed(context, route, arguments: args);
}

pushNamedWithArgs(BuildContext context, String route, Map<String, dynamic> args) {
  Navigator.pushNamed(context, route, arguments: args);
}

popAndPushNamed(BuildContext context, String route) {
  Navigator.popAndPushNamed(context, route);
}

pushNamed(BuildContext context, String route) {
  Navigator.pushNamed(context, route);
}

popWithResult(BuildContext context, dynamic result) {
  Navigator.pop(context, result);
}

pop(BuildContext context) {
  Navigator.pop(context);
}


