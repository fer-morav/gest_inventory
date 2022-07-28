import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

import '../utils/icons.dart';

class ProductComponent extends StatelessWidget {
  final Product product;
  final String? userPosition;
  final sizeReference = 700.0;

  const ProductComponent({
    Key? key,
    required this.product,
    required this.userPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        final args = {
          product_args: product,
          user_position_args: userPosition,
        };
        Navigator.pushNamed(context, see_product_info_route, arguments: args);
      },
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: getIcon(
              AppIcons.product,
              color: product.stock.toString() == "0.0"
                  ? Colors.redAccent
                  : Colors.greenAccent,
              size: 50,
            ),
          ),
          Expanded(
            child: Text(
              product.nombre,
              style: TextStyle(
                  color: primaryColor, fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "\$" + product.precioUnitario.toString(),
              style: TextStyle(
                  color: primaryColor, fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Stock: " + product.stock.toString(),
              style: TextStyle(
                  color: primaryColor, fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
