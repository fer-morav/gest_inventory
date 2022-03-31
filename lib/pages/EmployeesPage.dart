import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/utils/strings.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _Employees();
}

class _Employees extends State<EmployeesPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_employees,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_make_sale,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_stock,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_see_info_product,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_see_info_business,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonSecond(
                onPressed: () => _signOut(),
                text: button_logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut () async {
    if(await _authDataSource.signOut()){
      Phoenix.rebirth(context);
    }
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}