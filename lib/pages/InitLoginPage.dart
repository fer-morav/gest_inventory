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
          textAppBar: title_admin,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              height: 80,
              child: const Text.rich(
                TextSpan(
                  text: subTitle_InfoNego,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 60,
              child: const Text.rich(
                TextSpan(
                  text: NombreNegocio,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Dueño : " + DuenoNegocio,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                  const Text.rich(
                    TextSpan(
                      text: "Empleados : " + NoEmpleados,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(1000, 0, 68, 106),
                      ),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  ButtonMain(
                    text: button_verEmpleados,
                    isDisabled: true, 
                    onPressed: () {  },
                  ),
                ],
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Dirección : " + DirNeg,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Teléfono : " + TelNeg,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Correo : " + EmailNeg,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Fecha de Registro : " + FechaRegNeg,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: const Text.rich(
                TextSpan(
                  text: "Activo : " + ActivoNeg,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: button_ModInfo,
                isDisabled: true, 
                onPressed: () {  },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: button_CambContra,
                isDisabled: true, 
                onPressed: () {  },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: button_EliminarNeg,
                isDisabled: true, 
                onPressed: () {  },
              ),
            ),
          ],
        ),
      ),
      onWillPop: () => exit(0),
    );
  }
}
