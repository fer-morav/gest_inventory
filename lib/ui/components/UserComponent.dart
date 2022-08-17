import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'ProfileImageComponent.dart';

class UserComponent extends StatelessWidget {
  final User user;
  final String? userPosition;
  final sizeReference = 700.0;

  const UserComponent({
    Key? key,
    required this.user,
    this.userPosition,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        final args = {
          user_args: user,
          user_position_args: userPosition,
        };
        Navigator.pushNamed(context, see_profile_route, arguments: args);
      },
      backgroundColor: Colors.white,
      elevation: 8,
      isExtended: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 15),
            child: ProfileImageComponent(
              isAdmin: user.cargo == "[Administrador]",
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              user.nombre + " " + user.apellidos,
              style: TextStyle(
                  color: primaryColor,
                  //fontWeight: FontWeight.w900,
                  fontSize: getResponsiveText(17)),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
