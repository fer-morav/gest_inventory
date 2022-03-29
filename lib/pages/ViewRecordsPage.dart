import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

class ViewRecordsPage extends StatefulWidget {
  const ViewRecordsPage({Key? key}) : super(key: key);

  @override
  State<ViewRecordsPage> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecordsPage> {
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
              onPressed: () => _nextScreen(records_date_route),
              text: button_compras,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreen(records_date_route),
              text: button_ventas,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreen(records_date_route),
              text: button_ambos,
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
