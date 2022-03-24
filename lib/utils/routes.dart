import 'package:flutter/material.dart';
import 'package:gest_inventory/pages/AddBussinessPage.dart';
import 'package:gest_inventory/pages/StatisticsPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    records_route: (BuildContext context) => ViewRecordsPage(),
    addbus_route: (BuildContext context) => AddBussinessPage(),
    records_date_route: (BuildContext context) => ViewRecordsPage(),
    statistics_route: (BuildContext context) => StatisticsPage(),
  };
}


const login_route = 'login';
const records_route = 'records';
const addbus_route = "add_business";
const records_date_route = "records_date";
const statistics_route = "statistics";
