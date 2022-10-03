import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../data/models/Product.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import 'ImageComponent.dart';

class ProductInfoComponent extends StatelessWidget {
  final Product product;
  final sizeReference = 700.0;

  const ProductInfoComponent({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle _textStyle(double size, {Color color = primaryColor}) =>
        TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: _getResponsiveText(size),
          color: color,
        );

    return ListTile(
      leading: ImageComponent(
        color: product.stock.lowStocks() ? adminColor : employeeColor,
        photoURL: product.photoUrl,
        size: 22.5,
      ),
      title: Text(
        product.name,
        style: _textStyle(18, color: blackColor),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getIcon(AppIcons.barcode, color: primaryColor),
          Text(
            product.barcode,
            style: _textStyle(15, color: lightColor),
          )
        ],
      ),
    );
  }
}
