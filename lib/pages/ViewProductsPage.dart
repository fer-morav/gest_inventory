import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

class ViewProductsPage extends StatefulWidget {
  const ViewProductsPage({Key? key}) : super(key: key);

  @override
  State<ViewProductsPage> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewProductsPage> {
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
        textAppBar: "Productos",
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
              text: "Todo el inventario",
              isDisabled: true,
              onPressed: () => _nextScreen(view_all_products_route),
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              text: "Agregar Producto",
              isDisabled: true,
              onPressed: () => {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              text: "Buscar Producto",
              isDisabled: true,
              onPressed: () => {},
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
