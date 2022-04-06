import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBusinessPage.dart';
import 'package:gest_inventory/pages/EditBusinessProfilePage.dart';
import 'package:gest_inventory/pages/EditUserProfilePage.dart';
import 'package:gest_inventory/pages/EmployeeListPage.dart';
import 'package:gest_inventory/pages/InfoBusinessPage.dart';
import 'package:gest_inventory/pages/RecordDatePage.dart';
import 'package:gest_inventory/pages/RegisterEmployeePage.dart';
import 'package:gest_inventory/pages/StatisticsPage.dart';
import 'package:gest_inventory/pages/ViewAllProductsPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import '../pages/AdministratorPage.dart';
import '../pages/EmployeesPage.dart';
import '../pages/LoginPage.dart';
import '../pages/RegisterUserPage.dart';
import '../pages/ViewProductsPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    login_route: (BuildContext context) => const LoginPage(),
    register_user_route: (BuildContext context) => const RegisterUserPage(),
    employees_route: (BuildContext context) => const EmployeesPage(),
    administrator_route: (BuildContext context) => const AdministratorPage(),
    records_route: (BuildContext context) => const ViewRecordsPage(),
    add_business_route: (BuildContext context) => const AddBusinessPage(),
    statistics_route: (BuildContext context) => const StatisticsPage(),
    records_date_route: (BuildContext context) => const RecordDatePage(),
    register_employees_route: (BuildContext context) => const RegisterEmployeePage(),
    modify_profile_route: (BuildContext context) => const EditUserProfilePage(),
    list_employees_route: (BuildContext context) => const EmployeeListPage(),
    info_business_route: (BuildContext context) => const InfoBusinessPage(),
    view_products_route: (BuildContext context) => const ViewProductsPage(),
    view_all_products_route: (BuildContext context) => const ViewAllProductsPage(),
    modify_business_route: (BuildContext context) => const EditBusinessProfilePage(),
  };
}


const login_route = 'login';
const records_route = 'records';
const add_business_route = "add_business";
const records_date_route = "records_date";
const statistics_route = "statistics";
const register_user_route = 'register';
const register_employees_route = 'register_employee';
const employees_route = "employees";
const administrator_route = "administrator";
const modify_profile_route = "modify_profile";
const list_employees_route = "list_employees";
const info_business_route = "info_business";
const view_products_route = "view_products";
const view_all_products_route = "view_all_products";
const modify_business_route = "modify_business";
