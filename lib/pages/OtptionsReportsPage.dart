import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../data/models/User.dart';

class OptionsReportsPage extends StatefulWidget {
  const OptionsReportsPage({Key? key}) : super(key: key);

  @override
  State<OptionsReportsPage> createState() => _OptionsReports();
}

class _OptionsReports extends State<OptionsReportsPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseBusinessDataSource _businessDataSource =
  FirebaseBusinessDataSource();
  bool _isLoading = true;

  String? businessId;
  Business? _business;

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
          textAppBar: "Generar Reporte",
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
                onPressed: () {
                  _nextScreenArgs(
                      incomingsReport_route, _business!.id.toString());
                },
                text: "Entradas/Compras",
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  _nextScreenArgs(
                      salesReport_route, _business!.id.toString());
                },
                text: "Salidas/Ventas",
                isDisabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _getBusiness(String id) async {
    _businessDataSource.getBusiness(id).then((business) => {
      if (business != null)
        {
          setState(() {
            _business = business;
            _isLoading = false;
          }),
        }
    });
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    businessId = args[business_id_args];
    _getBusiness(businessId!);
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _signOut() async {
    if (await _authDataSource.signOut()) {
      Phoenix.rebirth(context);
    }
  }
}
