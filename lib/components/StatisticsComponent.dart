import 'package:flutter/material.dart';

import '../data/models/Sales.dart';
import '../utils/colors.dart';

class StatisticsComponent extends StatelessWidget {
  final Sales sales;
  final sizeReference = 700.0;

  const StatisticsComponent({Key? key, required this.sales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 8,
        isExtended: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Transform.scale(
                scale: 1.5,
                child: Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.greenAccent,
                ),
                alignment: Alignment.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Expanded(
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
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                "\$" + sales.total.toString(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getResponsiveText(15),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                (sales.ventasMayoreo + sales.ventasUnitario).toString(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getResponsiveText(15),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
