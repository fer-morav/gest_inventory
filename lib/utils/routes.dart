import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBusinessPage.dart';
import 'package:gest_inventory/pages/RecordDatePage.dart';
import 'package:gest_inventory/pages/StatisticsPage.dart';
import 'package:gest_inventory/pages/AddBussinessPage.dart';
import 'package:gest_inventory/pages/TempMainPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import '../pages/AdministratorPage.dart';
import '../pages/EmployeesPage.dart';
import '../pages/LoginPage.dart';
import '../pages/RegisterUserPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    login_route: (BuildContext context) => const LoginPage(),
    register_user_route: (BuildContext context) => const RegisterUserPage(),
    employees_route: (BuildContext context) => const EmployeesPage(),
    administrator_route: (BuildContext context) => const AdministratorPage(),
    records_route: (BuildContext context) => const ViewRecordsPage(),
    addbus_route: (BuildContext context) => const AddBusinessPage(),
    statistics_route: (BuildContext context) => const StatisticsPage(),
    records_date_route: (BuildContext context) => const RecordDatePage(),
  };
}


const login_route = 'login';
const records_route = 'records';
const addbus_route = "add_business";
const records_date_route = "records_date";
const statistics_route = "statistics";
const register_user_route = 'register';
const employees_route = "employees";
const administrator_route = "administrator";
