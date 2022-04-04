import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/utils/routes.dart';

import '../data/models/User.dart';

class InfoNegPage extends StatefulWidget {
  const InfoNegPage({Key? key}) : super(key: key);

  @override
  State<InfoNegPage> createState() => _InfoNegPageState();
}

class _InfoNegPageState extends State<InfoNegPage> {
  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
    
  );

  User ActUser = User(
    id: "",
    idNegocio: "",
    cargo: "",
    nombre: "",
    apellidos: "",
    telefono: 0,
    salario: 0.0,
  );

  Business NegUser = Business(
    id: "####",
    nombreNegocio: "####",
    nombreDueno: "####",
    direccion: "####",
    correo: "####",
    telefono: 0,
    activo: false, 
    idDueno: '',
  );



  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  late String _userId, _negId,_active="NO";
  
  void LoadData() {
    _userId = _authDataSource.getUserId()!;
    _userDataSource.getUser(_userId).then((user) => {if (user != Null) {
      ActUser = user!,
      _negId = ActUser.idNegocio,
      _businessDataSource.getBusiness(_negId).then((neg) => {if (neg != Null) {
        setState((){
          NegUser = neg!;
          if(NegUser.activo == true){
            _active="SI";
          }else{
            _active="NO";
          }
        })
      }}),
    }});
  }

  @override
  void initState(){
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      LoadData();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          textAppBar: "Administrador",//cambiar por el titulo de pantalla NegUser.nombreNegocio.toString()
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
                  text: "Información del Negocio",
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
              child:Text(
                "'' "+NegUser.nombreNegocio.toString()+" ''",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Text(
                "Propietario: "+NegUser.nombreDueno.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                const Text(
                  "Empleados: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(1000, 0, 68, 106),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                  ButtonMain(
                    text: "Ver Empleados",
                    isDisabled: true, 
                    onPressed: () => _nextScreen(""),
                  ),
                ],
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Text(
                "Dirección: "+NegUser.direccion.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Text(
                "Teléfono: "+NegUser.telefono.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 45,
              child: Text(
                "Correo: "+NegUser.correo.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            
            Container(
              padding: _padding,
              height: 45,
              child: Text(
                "Activo: "+_active,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(1000, 0, 68, 106),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: "Modificar Información",
                isDisabled: true, 
                onPressed: () => _nextScreen(mod_neg_route),
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: "Cambiar Contraseña",
                isDisabled: true, 
                onPressed: () {  },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                text: "Eliminar Negocio",
                isDisabled: true, 
                onPressed: () => _nextScreen(del_neg_route),
              ),
            ),
          ],
        ),
    );
  }
  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}
