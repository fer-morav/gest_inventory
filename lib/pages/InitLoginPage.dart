import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../data/models/User.dart';

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

  User newUser = User(
    id: "",
    idNegocio: "",
    cargo: "",
    nombre: "",
    apellidos: "",
    telefono: 0,
    salario: 0,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSouce = FirebaseUserDataSouce();

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
                onPressed: () {
                  _signUp();
                },
                text: button_login_help,
                isDisabled: true,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () {
                  _signIn();
                },
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

  String? _signUp() {
    /* La pantalla de registro donde se implementara esta funcion debe capturar
     del usuario su correo, contraseña para darlo de alta en firebase*/
    String email = "correoempleado@gmail.com";
    String password = "TestPassword";

    String? _userId;
    _authDataSource.signUpWithEmail(email, password).then((id) => {
      _userId = id,
      /* Esta funcion en caso de realizarse con exito la alta del usuario
          * retornara el ID unico que firebase le otorgo automaticamente*/
      _showToast("Sign up: " + _userId.toString()),
      /* Este id debera ser guardado en un objeto de tipo User junto con
          * toda la infomacion de la que este esta compuesto*/
      _saveChanges(_userId)
    });

    return _userId;
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
    });
    return _userId;
  }


  void _addUser() {
    /* La funcion para agregar usuario nesesitara de un objeto User el cual
    * ya debe tener toda la informacion capturada del usuario, este objeto sera
    * cargado en Cloud Firestore*/
    _userDataSouce.addUser(newUser).then((value) => {
      _showToast("Add user: " + value.toString()),
    });

  }

  void _saveChanges(String? id) {
    newUser.id = id ?? "";
    _addUser();
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