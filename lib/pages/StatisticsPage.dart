import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/pages/RecordDatePage.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_statistics,
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
              onPressed: () => _nextScreen(records_date_route),
              text: button_masvendidos,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreen(records_date_route),
              text: button_menosvendidos,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}
