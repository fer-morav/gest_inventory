import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Incomings.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

import '../data/models/Sales.dart';

class IncomingsComponent extends StatelessWidget {
  final Incomings incomings;
  final sizeReference = 700.0;

  const IncomingsComponent({
    Key? key,
    required this.incomings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        final args = {incomings_args: incomings};
        //avigator.pushNamed(context, see_product_info_route, arguments: args);
      },
      backgroundColor: Colors.white,
      elevation: 8,
      isExtended: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        //side: BorderSide(color: user.cargo == "[Administrador]" ? Colors.redAccent : Colors.greenAccent,),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: Transform.scale(
              scale: 1.6,
              child: Icon(
                Icons.arrow_circle_down,
                color: incomings.nombreProducto.toString() == "0.0"
                    ? Colors.redAccent
                    : Colors.greenAccent,
              ),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Text(
              incomings.nombreProducto,
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
          /*Expanded(
            child: Text(
              "Mayoreo: " + incomings.precioMayoreo.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(15)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Unitario: " + incomings.precioUnitario.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(15)),
              textAlign: TextAlign.left,
            ),
          ),*/
          Expanded(
            child: Text(
              "Total de unidades compradas: " + incomings.unidadesCompradas.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}