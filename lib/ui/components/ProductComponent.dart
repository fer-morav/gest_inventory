import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/ui/components/ImageComponent.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../utils/enums.dart';
import '../../utils/icons.dart';
import '../../utils/strings.dart';

class ProductComponent extends StatelessWidget {
  final Product product;
  final ActionType actionType;
  final Function()? onTap;
  final sizeReference = 700.0;

  const ProductComponent({
    Key? key,
    required this.product,
    this.onTap,
    required this.actionType,
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
      onTap: onTap,
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
      trailing: actionType == ActionType.delete
          ? getIcon(AppIcons.delete, color: errorColor)
          : Column(
              children: [
                Text(
                  '\$ ${product.unitPrice.toString()}',
                  textAlign: TextAlign.end,
                  style: textStyle(blackColor, 19),
                ),
                Text(
                  '$text_stock: ${product.stock.toString()}',
                  textAlign: TextAlign.end,
                  style: textStyle(blackColor, 19),
                ),
              ],
            ),
    );
  }
}
