import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
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
    double _getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle textStyle(Color color, double size) => TextStyle(
      color: color,
      fontSize: _getResponsiveText(size),
    );

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: adminColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: getIcon(AppIcons.price, color: primaryOnColor, size: 45),
      ),
      title: Text(
        '${sales.creationDate.toDate().toFormatDate()}',
        style: textStyle(blackColor, 18),
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        '${sales.creationDate.toDate().toFormatHour()}',
        style: textStyle(lightColor, 15),
        textAlign: TextAlign.left,
      ),
      trailing: Text(
        sales.units.toString(),
        style: textStyle(primaryColor, 18),
        textAlign: TextAlign.left,
      ),
    );
  }
}
