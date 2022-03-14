import 'package:flutter/material.dart';
import '../pages/InitLoginPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    init_login_route: (BuildContext context) => InitLoginPage(),
  };
}

const init_login_route = 'login';