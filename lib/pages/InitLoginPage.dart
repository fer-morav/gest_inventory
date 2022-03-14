import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/strings.dart';

class InitLoginPage extends StatefulWidget {
  const InitLoginPage({Key? key}) : super(key: key);

  @override
  State<InitLoginPage> createState() => _InitLoginPageState();
}

class _InitLoginPageState extends State<InitLoginPage> {
  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_login,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_login_admin,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_login_help,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {},
                text: button_recover_password,
                isDisabled: true,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () => exit(0),
    );
  }
}
