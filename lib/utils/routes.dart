import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBussinessPage.dart';
import 'package:gest_inventory/pages/TempMainPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import '../pages/InitLoginPage.dart';
import '../pages/RegisterUserPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    init_login_route: (BuildContext context) => InitLoginPage(),
    init_records_route: (BuildContext context) => ViewRecordsPage(),
    init_tmain_route: (BuildContext context) => TempMainPage(),
    init_addbus_route: (BuildContext context) => AddBussinessPage(),
    register_user_route: (BuildContext context) => RegisterUserPage(),
  };
}


const init_login_route = 'login';
const init_records_route = 'records';
const init_tmain_route = 'tmain';
const init_addbus_route = "addbus";

const register_user_route = 'register';