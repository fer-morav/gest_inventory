import 'package:flutter/material.dart';
import 'custom_icons.dart';

final _icons = <AppIcons, IconData>{
  AppIcons.search: Icons.search,
  AppIcons.product: Icons.shopping_bag_outlined,
  AppIcons.price: Icons.monetization_on_outlined,
  AppIcons.user: CustomIcons.user,
  AppIcons.edit: Icons.edit,
  AppIcons.qr: Icons.qr_code,
  AppIcons.add: Icons.add,
  AppIcons.scanner: CustomIcons.barcode,
  AppIcons.google: CustomIcons.google,
  AppIcons.delete: Icons.person_remove,
  AppIcons.gen_pdf: CustomIcons.picture_as_pdf,
  AppIcons.change: CustomIcons.arrows_ccw,
  AppIcons.arrow_back: Icons.arrow_back,
  AppIcons.show: Icons.visibility,
  AppIcons.hide: Icons.visibility_off,
  AppIcons.error: Icons.clear,
  AppIcons.ok: Icons.check,
};

Icon getIcon(AppIcons icon, {Color? color, double? size}) {
  return Icon(
    _icons[icon],
    color: color,
    size: size,
  );
}

enum AppIcons {
  search,
  product,
  price,
  user,
  edit,
  add,
  qr,
  scanner,
  google,
  delete,
  gen_pdf,
  change,
  arrow_back,
  show,
  hide,
  ok,
  error
}
