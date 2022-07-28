import 'package:flutter/material.dart';
import '../data/models/Sales.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class StatisticsComponent extends StatelessWidget {
  final Sales sales;
  final sizeReference = 700.0;

  const StatisticsComponent({Key? key, required this.sales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {},
      backgroundColor: Colors.white,
      elevation: 8,
      isExtended: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: getIcon(
              AppIcons.price,
              color: Colors.green,
              size: 40,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                sales.nombreProducto,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getResponsiveText(15),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "\$" + sales.total.toString(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getResponsiveText(15),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 60),
              child: Text(
                (sales.ventasMayoreo + sales.ventasUnitario).toString(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getResponsiveText(15),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
