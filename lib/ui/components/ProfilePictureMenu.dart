import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/colors.dart';

class ProfilePictureMenu extends StatelessWidget {
  const ProfilePictureMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title_select_option,
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: getIcon(AppIcons.take_photo, color: blackColor),
            title: Text(
              button_take_photo,
              style: TextStyle(color: blackColor),
            ),
            onTap: () {
              Navigator.of(context).pop(button_take_photo);
            },
          ),
          ListTile(
            leading: getIcon(AppIcons.pick_photo, color: blackColor),
            title: Text(
              button_pick_picture,
              style: TextStyle(color: blackColor),
            ),
            onTap: () {
              Navigator.of(context).pop(button_pick_picture);
            },
          ),
          ListTile(
            leading: getIcon(AppIcons.delete_photo, color: errorColor),
            title: Text(
              button_delete_photo,
              style: TextStyle(color: errorColor),
            ),
            onTap: () {
              Navigator.of(context).pop(button_delete_photo);
            },
          ),
        ],
      ),
    );
  }
}
