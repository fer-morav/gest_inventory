import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Sales.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../utils/icons.dart';

class RecordsComponent extends StatelessWidget {
  final Map<String, dynamic> values;
  final bool sales;
  final sizeReference = 700.0;

  const RecordsComponent({
    Key? key,
    required this.values,
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

    return ListTile(
      leading: sales
          ? Container(
              decoration: BoxDecoration(
                color: adminColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: getIcon(AppIcons.price, color: primaryOnColor, size: 45),
            )
          : getIcon(AppIcons.add_product, color: employeeColor, size: 45),
      title: Text(
        '${(values[Sales.FIELD_CREATION_DATE] as Timestamp).toDate().toFormatDate()}',
        style: textStyle(blackColor, 18),
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        '${(values[Sales.FIELD_CREATION_DATE] as Timestamp).toDate().toFormatHour()}',
        style: textStyle(lightColor, 15),
        textAlign: TextAlign.left,
      ),
      trailing: Text(
        values[Sales.FIELD_UNITS].toString(),
        style: textStyle(primaryColor, 18),
        textAlign: TextAlign.left,
      ),
    );
  }
}
