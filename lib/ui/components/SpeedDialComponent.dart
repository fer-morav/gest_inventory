import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gest_inventory/utils/actions_enum.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';

class SpeedDialComponent extends SpeedDial {
  SpeedDialComponent({
    required ActionType actionType,
    required List<SpeedDialChild> children,
    Function()? onPressed,
  }) : super(
          icon: actionType != ActionType.select
              ? getIconData(AppIcons.ok)
              : getIconData(AppIcons.options),
          activeIcon: getIconData(AppIcons.error),
          backgroundColor: primaryColor,
          overlayOpacity: 0.25,
          overlayColor: blackColor,
          visible: true,
          curve: Curves.bounceIn,
          shape: CircleBorder(),
          onPress: onPressed,
          children: children,
        );
}

// class SpeedDialComponent extends StatelessWidget {
//   final ActionType actionType;
//   final Function()? onPressed;
//   final List<SpeedDialChild> children;
//
//   const SpeedDialComponent({
//     Key? key,
//     required this.actionType,
//     this.onPressed,
//     required this.children,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SpeedDial(
//       icon: actionType != ActionType.select
//           ? getIconData(AppIcons.ok)
//           : getIconData(AppIcons.options),
//       activeIcon: getIconData(AppIcons.error),
//       backgroundColor: primaryColor,
//       overlayOpacity: 0.25,
//       overlayColor: blackColor,
//       visible: true,
//       curve: Curves.bounceIn,
//       shape: CircleBorder(),
//       onPress: onPressed,
//       children: children,
//     );
//   }
// }
