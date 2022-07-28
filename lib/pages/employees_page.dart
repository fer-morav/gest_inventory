import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../data/firebase/FirebaseAuthDataSource.dart';
import '../data/models/User.dart';
import '../utils/routes.dart';

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

  User? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

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
                onPressed: () {_nextScreenArgs(make_sale_route, user!.idNegocio.toString(), user!.cargo);},
                text: button_make_sale,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {_nextScreenArgs(
                      optionsList_product_page, user!.idNegocio.toString(), user!.cargo);},
                text: button_see_info_product,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {_nextScreenArgs(
                      info_business_route, user!.idNegocio.toString(), user!.cargo);},
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

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }
    user = args[user_args];
  }

  void _nextScreenArgs(String route, String businessId, String userPosition) {
    final args = {business_id_args: businessId,user_position_args:userPosition};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _signOut () async {
    if(await _authDataSource.signOut()){
      Phoenix.rebirth(context);
    }
  }
}