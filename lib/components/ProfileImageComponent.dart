import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class ProfileImageComponent extends StatefulWidget {
  final bool isAdmin;
  final String? photoURL;
  final double size;

  const ProfileImageComponent({
    Key? key,
    required this.isAdmin,
    this.photoURL,
    required this.size,
  }) : super(key: key);

  @override
  State<ProfileImageComponent> createState() => _ProfileImageComponentState();
}

class _ProfileImageComponentState extends State<ProfileImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: widget.isAdmin ? adminColor : employeeColor,
        radius: widget.size,
        child: widget.photoURL != null
            ? CircleAvatar(
                radius: widget.size / 1.075,
                backgroundImage: NetworkImage(widget.photoURL!))
            : CircleAvatar(
                radius: widget.size / 1.075,
                backgroundColor: lightColor,
                child: getIcon(
                  AppIcons.user,
                  color: widget.isAdmin ? adminColor : employeeColor,
                  size: widget.size,
                ),
              ),
      ),
    );
  }
}
