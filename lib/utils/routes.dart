import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBussinessPage.dart';
import 'package:gest_inventory/pages/TempMainPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import '../pages/InitLoginPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    init_login_route: (BuildContext context) => InitLoginPage(),
    init_records_route: (BuildContext context) => ViewRecordsPage(),
    init_tmain_route: (BuildContext context) => TempMainPage(),
    init_addbus_route: (BuildContext context) => AddBussinessPage(),
  };
}


const init_login_route = 'login';
const init_records_route = 'records';
const init_tmain_route = 'tmain';
const init_addbus_route = "addbus";
