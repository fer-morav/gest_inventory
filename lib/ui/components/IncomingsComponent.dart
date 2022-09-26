import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../utils/icons.dart';

class IncomingComponent extends StatelessWidget {
  final Incoming incoming;
  final sizeReference = 700.0;

  const IncomingComponent({
    Key? key,
    required this.incoming,
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
          color: employeeColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: getIcon(AppIcons.edit_product, color: primaryOnColor, size: 45),
      ),
      title: Text(
        '${incoming.creationDate.toDate().toFormatDate()}',
        style: textStyle(blackColor, 18),
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        '${incoming.creationDate.toDate().toFormatHour()}',
        style: textStyle(lightColor, 15),
        textAlign: TextAlign.left,
      ),
      trailing: Text(
        incoming.units.toString(),
        style: textStyle(primaryColor, 18),
        textAlign: TextAlign.left,
      ),
    );
  }
}
