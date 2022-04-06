import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

class ProductComponent extends StatelessWidget {
  final Product product;
  final sizeReference = 700.0;

  const ProductComponent({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        final args = {"args": product};
        Navigator.pushNamed(context, see_product_info_route, arguments: args);
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
                Icons.shopping_bag_outlined,
                color:
                    product.stock.toString() == "0.0" ? Colors.redAccent : Colors.greenAccent,
              ),
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Text(
              product.nombre,
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "\$ "+product.precioUnitario.toString(),
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              "Stock: "+product.stock.toString(),
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
