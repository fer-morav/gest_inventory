import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/add_business_page.dart';
import 'package:gest_inventory/pages/add_product_page.dart';
import 'package:gest_inventory/pages/incomes_page.dart';
import 'package:gest_inventory/pages/update_business_page.dart';
import 'package:gest_inventory/pages/update_product_page.dart';
import 'package:gest_inventory/pages/update_user_page.dart';
import 'package:gest_inventory/pages/employees_list_page.dart';
import 'package:gest_inventory/pages/business_page.dart';
import 'package:gest_inventory/pages/make_sale_page.dart';
import 'package:gest_inventory/pages/record_date_page.dart';
import 'package:gest_inventory/pages/add_employee_page.dart';
import 'package:gest_inventory/pages/restock_page.dart';
import 'package:gest_inventory/pages/search_product_page.dart';
import 'package:gest_inventory/pages/statistics_page.dart';
import 'package:gest_inventory/pages/records_page.dart';
import 'package:gest_inventory/pages/sales_page.dart';
import '../pages/administrator_page.dart';
import '../pages/employees_page.dart';
import '../pages/login_page.dart';
import '../pages/add_user_page.dart';
import '../pages/search_product_code_page.dart';
import '../pages/user_page.dart';
import '../pages/options_products_page.dart';
import '../pages/products_page.dart';
import '../pages/product_page.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    login_route: (BuildContext context) => const LoginPage(),
    register_user_route: (BuildContext context) => const AddUserPage(),
    employees_route: (BuildContext context) => const EmployeesPage(),
    administrator_route: (BuildContext context) => const AdministratorPage(),
    records_route: (BuildContext context) => const RecordsPage(),
    add_business_route: (BuildContext context) => const AddBusinessPage(),
    statistics_route: (BuildContext context) => const StatisticsPage(),
    records_date_route: (BuildContext context) => const RecordDatePage(),
    register_employees_route: (BuildContext context) => const AddEmployeePage(),
    modify_profile_route: (BuildContext context) => const UpdateUserPage(),
    list_employees_route: (BuildContext context) => const EmployeesListPage(),
    see_profile_route: (BuildContext context) => const UserPage(),
    info_business_route: (BuildContext context) => const BusinessPage(),
    add_product_page: (BuildContext context) => const AddProductPage(),
    optionsList_product_page: (BuildContext context) => const OptionsProductsPage(),
    allList_product_page: (BuildContext context) => const ProductsPage(),
    see_product_info_route: (BuildContext context) => const SeeInfoProductPage(),
    edit_business_route: (BuildContext context) => const UpdateBusinessPage(),
    search_product_route: (BuildContext context) => const SearchProductPage(),
    modify_product_route: (BuildContext context) => const UpdateProductPage(),
    search_product_code_route: (BuildContext context) => const SearchProductCodePage(),
    make_sale_route: (BuildContext context) => const MakeSalePage(),
    restock_route: (BuildContext context) => const RestockPage(),
    allsales_route: (BuildContext context) => const SalesPage(),
    allincomes_route: (BuildContext context) => const IncomesPage(),
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
const see_profile_route = "see_profile";
const info_business_route = "info_business";
const add_product_page = "add_product";
const optionsList_product_page = "opList_product";
const allList_product_page = "allList_products";
const see_product_info_route = "see_info_products";
const edit_business_route = "edit_business";
const search_product_route = "search_product";
const modify_product_route = "modify_product";
const search_product_code_route = "search_product_code";
const make_sale_route = "make_sale";
const restock_route = "restock";
const allsales_route = "all_sales";
const allincomes_route = "all_incomes";