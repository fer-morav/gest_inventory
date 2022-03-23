import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/strings.dart';

class RecordDatePage extends StatefulWidget {
  const RecordDatePage({Key? key}) : super(key: key);

  @override
  State<RecordDatePage> createState() => _RecordDateState();
}

class _RecordDateState extends State<RecordDatePage> {
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
          textAppBar: title_report,
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
                text: button_hoy,
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
                text: button_semana,
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
                text: button_mes,
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
