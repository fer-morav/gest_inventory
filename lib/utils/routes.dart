import 'package:flutter/material.dart';
import 'package:gest_inventory/ui/pages/business_page.dart';
import 'package:gest_inventory/ui/pages/employees_page.dart';
import 'package:gest_inventory/ui/pages/inform_page.dart';
import 'package:gest_inventory/ui/pages/make_sale_page.dart';
import 'package:gest_inventory/ui/pages/restock_page.dart';
import 'package:gest_inventory/ui/pages/splash_page.dart';
import 'package:gest_inventory/ui/pages/statistics_page.dart';
import 'package:gest_inventory/ui/pages/records_page.dart';
import 'package:gest_inventory/ui/pages/waiting_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/user_page.dart';
import '../ui/pages/register_user_page.dart';
import '../ui/pages/list_products_page.dart';
import '../ui/pages/product_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    splash_route: (BuildContext context) => const SplashPage(),
    login_route: (BuildContext context) => const LoginPage(),
    register_user_route: (BuildContext context) => RegisterUserPage(),
    home_route: (BuildContext context) => const HomePage(),
    user_route: (BuildContext context) => const UserPage(),
    waiting_route: (BuildContext context) => WaitingPage(),
    business_route: (BuildContext context) => const BusinessPage(),
    employees_route: (BuildContext context) => const EmployeesPage(),
    list_products_route: (BuildContext context) => const ListProductsPage(),
    product_route: (BuildContext context) => const ProductPage(),
    make_sale_route: (BuildContext context) => const MakeSalePage(),
    statistics_route: (BuildContext context) => const StatisticsPage(),
    records_route: (BuildContext context) => const RecordsPage(),
    restock_route: (BuildContext context) => const RestockPage(),
    inform_route: (BuildContext context) => const InformPage(),
  };
}

const splash_route = 'splash';
const login_route = 'login';
const register_user_route = 'register';
const home_route = 'home';
const user_route = 'edit_user';
const business_route = 'business';
const waiting_route = 'waiting';
const employees_route = 'employees';
const list_products_route = 'list_products';
const product_route = 'product';
const make_sale_route = 'make_sale';
const statistics_route = 'statistics';
const records_route = 'records';
const restock_route = 'restock';
const inform_route = 'inform';