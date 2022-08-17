import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import '../../data/models/Sales.dart';
import '../../utils/icons.dart';

class SalesComponent extends StatelessWidget {
  final Sales sales;
  final sizeReference = 700.0;

  const SalesComponent({
    Key? key,
    required this.sales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        final args = {sales_args: sales};
      },
      backgroundColor: Colors.white,
      elevation: 8,
      isExtended: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        //side: BorderSide(color: user.cargo == "[Administrador]" ? Colors.redAccent : Colors.greenAccent,),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: getIcon(AppIcons.price, color: Colors.greenAccent, size: 45)
          ),
          Expanded(
            child: Text(
              sales.nombreProducto,
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(14)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Mayoreo: " + sales.ventasMayoreo.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(14)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Unitario: " + sales.ventasUnitario.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(14)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Total: \$" + sales.total.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(14)),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
