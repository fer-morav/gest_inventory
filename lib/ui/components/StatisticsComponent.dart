import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../data/models/Product.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import 'ImageComponent.dart';

class StatisticsComponent extends StatelessWidget {
  final Product product;
  final List<int> values;
  final bool sales;
  final sizeReference = 700.0;

  const StatisticsComponent({
    Key? key,
    required this.values,
    required this.product,
    this.sales = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle textStyle(Color color, double size) => TextStyle(
          color: color,
          fontSize: _getResponsiveText(size),
        );

    double _calculateTotalSale() {
      var total = 0.0;

      values.forEach((value) {
        if (value >= 10) {
          total += product.wholesalePrice * value;
        } else {
          total += product.unitPrice * value;
        }
      });

      return total;
    }

    double _calculateTotalUnits() {
      var total = 0.0;

      values.forEach((value) => total += value);

      return total;
    }

    return ListTile(
      leading: ImageComponent(
        color: product.stock.lowStocks() ? adminColor : employeeColor,
        photoURL: product.photoUrl,
        size: 22.5,
      ),
      title: Text(
        product.name,
        style: TextStyle(
          color: blackColor,
          fontSize: _getResponsiveText(18),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getIcon(AppIcons.barcode, color: primaryColor),
              Text(
                product.barcode,
                style: textStyle(lightColor, 12.5),
              )
            ],
          ),
          sales
              ? Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    '\$ ${_calculateTotalSale()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: _getResponsiveText(20),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 17.5, right: 30),
        child: Text(
          _calculateTotalUnits().toString(),
          style: TextStyle(
            color: primaryColor,
            fontSize: _getResponsiveText(20),
          ),
        ),
      ),
    );
  }
}
