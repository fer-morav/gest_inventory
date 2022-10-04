import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/ui/components/ImageComponent.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/icons.dart';

class UserComponent extends StatelessWidget {
  final User user;
  final Function()? onTap;
  final ActionType actionType;
  final sizeReference = 700.0;

  const UserComponent({
    Key? key,
    required this.user,
    this.onTap,
    this.actionType = ActionType.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return ListTile(
      onTap: onTap,
      leading: ImageComponent(
        color: user.admin ? adminColor : employeeColor,
        photoURL: user.photoUrl,
        size: 28.5,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          color: blackColor,
          fontWeight: FontWeight.w500,
          fontSize: getResponsiveText(25),
        ),
      ),
      isThreeLine: true,
      subtitle: Text(
        '${user.phoneNumber.toString()} \n${user.email}',
        style: TextStyle(
          color: lightColor,
          fontWeight: FontWeight.w500,
          fontSize: getResponsiveText(15),
        ),
      ),
      trailing: actionType == ActionType.edit
          ? getIcon(AppIcons.edit, color: primaryColor)
          : actionType == ActionType.delete
              ? getIcon(AppIcons.delete, color: errorColor)
              : getIcon(AppIcons.next, color: blackColor),
    );
  }
}
