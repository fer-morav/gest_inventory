import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

import '../../utils/icons.dart';


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

    double _getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return InkWell(
      onTap: () => _productPage(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: primaryOnColor,
            child: getIcon(
              AppIcons.product,
              color: product.stock.toString() == "0.0"
                  ? Colors.redAccent
                  : Colors.greenAccent,
              size: 50,
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.57,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nombre,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: _getResponsiveText(25),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    getIcon(
                      AppIcons.scanner,
                      color: primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      product.id,
                      style: TextStyle(
                        color: lightColor,
                        fontSize: _getResponsiveText(17),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$" + product.precioUnitario.toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: blackColor,
                  fontSize: _getResponsiveText(19),
                ),
              ),
              Text(
                "Stock: " + product.stock.toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: blackColor,
                  fontSize: _getResponsiveText(19),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _productPage(BuildContext context) {
    final args = {
      product_args: product,
      user_position_args: userPosition,
    };
    Navigator.pushNamed(context, see_product_info_route, arguments: args);
  }
}
