import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class DataTableComponent extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? currentSortColumn;
  final bool isAscending;
  final sizeReference = 700;

  const DataTableComponent({
    Key? key,
    required this.columns,
    required this.rows,
    this.currentSortColumn = null,
    this.isAscending = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle _textHeadingStyle(double size) => TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: getResponsiveText(size),
      color: primaryOnColor,
    );

    TextStyle _textDataStyle(double size) => TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: getResponsiveText(size),
      color: primaryDark,
    );

    return DataTable(
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all(primaryColor),
      headingTextStyle: _textHeadingStyle(20),
      dataTextStyle: _textDataStyle(20),
      dataRowHeight: 75,
      border: TableBorder.all(color: primaryOnColor),
      sortColumnIndex: currentSortColumn,
      sortAscending: isAscending,
      columns: columns,
      rows: rows,
    );
  }
}
