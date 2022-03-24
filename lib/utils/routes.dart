import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AdministratorPage.dart';
import 'package:gest_inventory/pages/EmployeesPage.dart';
import 'package:gest_inventory/pages/RegisterUserPage.dart';
import '../pages/LoginPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    login_route: (BuildContext context) => LoginPage(),
    register_user_route: (BuildContext context) => RegisterUserPage(),
    employees_route: (BuildContext context) => EmployeesPage(),
    administrator_route: (BuildContext context) => AdministratorPage()
  };
}

const login_route = 'login';
const register_user_route = 'register';
const employees_route = "employees";
const administrator_route = "administrator";