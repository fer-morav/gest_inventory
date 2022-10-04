import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/icons.dart';
import '../../utils/scan_util.dart';
import '../../utils/strings.dart';
import 'DividerComponent.dart';
import 'ProductComponent.dart';

class SearchProductDelegate extends SearchDelegate<Product?> {
  final List<Product> products;
  final ActionType actionType;

  List<Product> _listQuery = [];

  SearchProductDelegate({required this.products, required this.actionType});

  @override
  String? get searchFieldLabel => '$textfield_label_name o $textfield_label_id';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: _scanBarcode,
        icon: getIcon(AppIcons.scanner, size: 30, color: primaryColor),
      ),
      IconButton(
        onPressed: () => query = '',
        icon: getIcon(AppIcons.error, size: 30, color: errorColor),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: getIcon(AppIcons.arrow_back, color: primaryColor, size: 30),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _listQuery = _getQuery();

    return ListView.separated(
      itemCount: _listQuery.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return ProductComponent(
          product: _listQuery[index],
          actionType: actionType,
          onTap: () => close(context, _listQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _listQuery = _getQuery();

    return ListView.separated(
      itemCount: _listQuery.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return ProductComponent(
          product: _listQuery[index],
          actionType: actionType,
          onTap: () => close(context, _listQuery[index]),
        );
      },
    );
  }

  List<Product> _getQuery() {
    return products.where(
          (product) {
        return product.name.toLowerCase().contains(query.toLowerCase().trim()) ||
            product.barcode.toLowerCase().contains(query.toLowerCase().trim());
      },
    ).toList();
  }

  void _scanBarcode() async {
    query = await ScanUtil.scanBarcodeNormal();
  }
}
