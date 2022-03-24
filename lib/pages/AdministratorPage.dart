import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/strings.dart';

class AdministratorPage extends StatefulWidget {
  const AdministratorPage({Key? key}) : super(key: key);

  @override
  State<AdministratorPage> createState() => _Administrator();
}

class _Administrator extends State<AdministratorPage> {
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
          textAppBar: title_administrator,
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
                  Navigator.pop(context);
                },
                text: button_employees_list,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: button_restock,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: button_administrator_sale,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: button_administrator_stock,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: button_records,
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