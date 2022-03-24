import 'package:flutter/material.dart';
import '../pages/LoginPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    register_user_route: (BuildContext context) => RegisterUserPage(),
  };
}

const init_login_route = 'login';
const register_user_route = 'register';