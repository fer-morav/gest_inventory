import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../data/models/Product.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import 'ImageComponent.dart';

class SaleProductComponent extends StatelessWidget {
  final Product product;
  final int quantity;
  final Function()? addTap;
  final Function()? removeTap;
  final sizeReference = 700.0;

  const SaleProductComponent({
    Key? key,
    required this.product,
    this.addTap,
    this.removeTap,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle textStyle(Color color, double size) => TextStyle(
      color: color,
      fontSize: _getResponsiveText(size),
    );

    return ListTile(
      leading: ImageComponent(
        color: product.stock.lowStocks() ? adminColor : employeeColor,
        photoURL: product.photoUrl,
        size: 28.5,
      ),
      title: Text(
        product.name,
        style: TextStyle(
          color: blackColor,
          fontSize: _getResponsiveText(25),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getIcon(AppIcons.barcode, color: primaryColor),
          Text(
            product.barcode,
            style: textStyle(lightColor, 17),
          )
        ],
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: removeTap,
            iconSize: 30,
            icon: getIcon(AppIcons.remove),
            disabledColor: lightColor,
            color: primaryColor,
          ),
          Column(
            children: [
              Text(
                '\$ ${quantity >= 10 ? product.wholesalePrice.toString() : product.unitPrice.toString()}',
                textAlign: TextAlign.end,
                style: textStyle(blackColor, 19),
              ),
              Text(
                '$quantity / ${product.stock.toInt().toString()}',
                textAlign: TextAlign.end,
                style: textStyle(blackColor, 19),
              ),
            ],
          ),
          IconButton(
            onPressed: addTap,
            iconSize: 30,
            icon: getIcon(AppIcons.add),
            disabledColor: lightColor,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}