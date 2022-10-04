import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/icons.dart';

class ImageProfileComponent extends StatelessWidget {
  final bool admin;
  final ImageProvider image;
  final Function() onPressed;

  const ImageProfileComponent({
    Key? key,
    required this.admin,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: admin ? adminColor : employeeColor,
      child: CircleAvatar(
        radius: 110,
        backgroundColor: primaryOnColor,
        backgroundImage: image,
        child: Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: onPressed,
            child: CircleAvatar(
              radius: 27,
              backgroundColor: admin ? adminColor : employeeColor,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: primaryColor,
                child: getIcon(
                  AppIcons.add_photo,
                  color: primaryOnColor,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
