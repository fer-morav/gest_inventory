import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBussinessDataSource.dart';
import '../data/models/Bussiness.dart';


class AddBussinessPage extends StatefulWidget {
  const AddBussinessPage({Key? key}) : super(key: key);

  @override
  State<AddBussinessPage> createState() => _AddBussinessState();
}

class _AddBussinessState extends State<AddBussinessPage> {
  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
  );

  Bussiness newBussiness = Bussiness(
    id: "",
    idNegocio: "",
    nombreNegocio: "",
    nombreDueno: "",
    direccion: "",
    correo: "",
    telefono: 0,
    activo: false,
  );


  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseBussinessDataSouce _bussinessDataSource = FirebaseBussinessDataSouce();

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: "AÑADIR NEGOCIO",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nombre del negocio:",
                    hintText: 'Ingrese aqui el nombre del negocio'
                ),
                onChanged: (text){
                  newBussiness.nombreNegocio = text;
                },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nombre del dueño:",
                    hintText: 'Ingrese aqui el nombre del dueño negocio'
                ),
                onChanged: (text){
                  newBussiness.nombreDueno = text;
                },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Dirección del negocio:",
                    hintText: 'Ingrese aqui la dirección del negocio'
                ),
                onChanged: (text){
                  newBussiness.direccion = text;
                },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Telefono del negocio:",
                    hintText: 'Ingrese aqui el telefono del negocio'
                ),
                onChanged: (text) {
                  newBussiness.telefono = int.parse(text);
                },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Correo del negocio:",
                    hintText: 'Ingrese aqui el correo del negocio'
                ),
                onChanged: (text){
                  newBussiness.correo = text;
                },
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  _signIn();
                },
                text: "Añadir negocio",
                isDisabled: false,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () => exit(0),
    );
  }

  String? _signIn() {
    /* Los siguientes valores seran remplazados por los datos de email y
    * contraseña capturados del usuario, si el usuario ya registro sus
    * credenciales podra iniciar sesion sin problemas*/

    String email = "fer.1998.madrid@gmail.com";
    String password = "TestPassword";

    String? _userId;
    _authDataSource.signInWithEmail(email, password).then((id) =>
    {_userId = id,
      _showToast("Sign in: " + _userId.toString()),
      _saveChanges(_userId),
    });
    return _userId;
  }

  void _addBussiness() {
    /* La funcion para agregar usuario nesesitara de un objeto User el cual
    * ya debe tener toda la informacion capturada del usuario, este objeto sera
    * cargado en Cloud Firestore*/
    _bussinessDataSource.addBussines(newBussiness).then((value) => {
      _showToast("Add bussiness: " + value.toString()),
    });

  }

  void _saveChanges(String? id) {
    newBussiness.id = id ?? "";
    _addBussiness();
  }

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


