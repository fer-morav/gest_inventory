import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/pages/AddBussinessPage.dart';
import 'package:gest_inventory/pages/StatisticsPage.dart';
import 'package:gest_inventory/pages/ViewRecordsPage.dart';
import 'package:gest_inventory/utils/strings.dart';

class TempMainPage extends StatefulWidget {
  const TempMainPage({Key? key}) : super(key: key);

  @override
  State<TempMainPage> createState() => _TempMainState();
}

class _TempMainState extends State<TempMainPage> {
  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_tmain,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewRecordsPage()),
                  );
                },
                text: button_report,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatisticsPage()),
                  );
                },
                text: button_statistics,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBussinessPage()),
                  );
                },
                text: "Añadir Negocio",
                isDisabled: true,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () => exit(0),
    );
  }
}
