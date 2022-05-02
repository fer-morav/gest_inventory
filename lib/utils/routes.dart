import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBusinessPage.dart';
import 'package:gest_inventory/pages/AddProductPage.dart';
import 'package:gest_inventory/pages/AllIncomesPage.dart';
import 'package:gest_inventory/pages/EditBusinessProfilePage.dart';
import 'package:gest_inventory/pages/EditProductPage.dart';
import 'package:gest_inventory/pages/EditUserProfilePage.dart';
import 'package:gest_inventory/pages/EmployeeListPage.dart';
import 'package:gest_inventory/pages/IncomingsReportPage.dart';
import 'package:gest_inventory/pages/SalesReportPage.dart';
import 'package:gest_inventory/pages/InfoBusinessPage.dart';
import 'package:gest_inventory/pages/MakeSalePage.dart';
import 'package:gest_inventory/pages/OtptionsReportsPage.dart';
import 'package:gest_inventory/pages/RecordDatePage.dart';
import 'package:gest_inventory/pages/RegisterEmployeePage.dart';
import 'package:gest_inventory/pages/RestockPage.dart';
import 'package:gest_inventory/pages/SearchProductPage.dart';
import 'package:gest_inventory/pages/StatisticsPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import 'package:gest_inventory/pages/AllSalesPage.dart';
import '../pages/AdministratorPage.dart';
import '../pages/EmployeesPage.dart';
import '../pages/LoginPage.dart';
import '../pages/RegisterUserPage.dart';
import '../pages/SearchProductCodePage.dart';
import '../pages/SeeInfoUserPage.dart';
import '../pages/OptionsListProductsPage.dart';
import '../pages/AllListProductsPage.dart';
import '../pages/SeeProductInfoPage.dart';


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
    see_profile_route: (BuildContext context) => const SeeInfoUserPage(),
    info_business_route: (BuildContext context) => const InfoBusinessPage(),
    add_product_page: (BuildContext context) => const AddProductPage(),
    optionsList_product_page: (BuildContext context) => const OptionsListProductsPage(),
    allList_product_page: (BuildContext context) => const AllListProductsPage(),
    see_product_info_route: (BuildContext context) => const SeeInfoProductPage(),
    edit_business_route: (BuildContext context) => const EditBusinessProfilePage(),
    search_product_route: (BuildContext context) => const SearchProductPage(),
    modify_product_route: (BuildContext context) => const EditProductPage(),
    search_product_code_route: (BuildContext context) => const SearchProductCodePage(),
    make_sale_route: (BuildContext context) => const MakeSalePage(),
    restock_route: (BuildContext context) => const RestockPage(),
    allsales_route: (BuildContext context) => const AllSalesPage(),
    optionsReports_route: (BuildContext context) => const OptionsReportsPage(),
    salesReport_route: (BuildContext context) => const SalesReportPage(),
    incomingsReport_route: (BuildContext context) => const IncomingsReportPage(),
    allincomes_route: (BuildContext context) => const AllIncomesPage(),
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
const optionsReports_route = "options_reports";
const salesReport_route = "sales_report";
const incomingsReport_route = "incomings_report";
const allincomes_route = "all_incomes";
