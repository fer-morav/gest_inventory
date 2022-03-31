import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextFieldMain.dart';
import 'package:gest_inventory/pages/LoginPage.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';

class ModifyAdminProfilePage extends StatefulWidget {
  const ModifyAdminProfilePage({Key? key}) : super(key: key);

  @override
  State<ModifyAdminProfilePage> createState() => _ModifyAdminProfilePageState();
}

class _ModifyAdminProfilePageState extends State<ModifyAdminProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController idNegocioController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController salarioController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  User newUser = User(
    id: "",
    idNegocio: "",
    cargo: "",
    nombre: "",
    apellidos: "",
    telefono: 0,
    salario: 0.0,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Administrador",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Correo Electronico",
              labelText: "Correo Electronico",
              textEditingController: emailController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Contraseña",
              labelText: "Contraseña",
              textEditingController: passwordController,
              isPassword: true,
              isPasswordTextStatus: showPassword,
              onTap: _showPassword,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "ID negocio",
              labelText: "ID negocio",
              textEditingController: idNegocioController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Nombre",
              labelText: "Nombre",
              textEditingController: nombreController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Apellidos",
              labelText: "Apellidos",
              textEditingController: apellidosController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Telefono",
              labelText: "Telefono",
              textEditingController: telefonoController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              isNumber: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: "Salario",
              labelText: "Salario",
              textEditingController: salarioController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              isNumber: true,
            ),
          ),
          Container(
            padding: _padding,
            child: MultiSelect(
                cancelButtonText: "Cancelar",
                saveButtonText: "Guardar",
                clearButtonText: "Reiniciar",
                titleText: "Roles",
                checkBoxColor: Colors.blue,
                selectedOptionsInfoText: "",
                hintText: "Cargo",
                maxLength: 1,
                dataSource: const [
                  {"cargo": "Empleado", "code": "Empleado"},
                  {"cargo": "Administrador", "code": "Administrador"},
                ],
                textField: 'cargo',
                valueField: 'code',
                filterable: true,
                required: true,
                onSaved: (value) {
                  cargoController.text = value.toString();
                }),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: (){
                _modifyAdmin();
              },
              text: "Guardar Cambios",
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: (){
                Navigator.pop(context);
              },
              text: "Cancelar",
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _modifyAdmin() {
    String email = emailController.text;
    String password = passwordController.text;
    String nombre = nombreController.text;
    String apellidos = apellidosController.text;
    double salario = double.parse(salarioController.text);
    int telefono = int.parse(telefonoController.text);
    String cargo = cargoController.text;
    String idNegocio = idController.text;

      newUser.nombre = nombre;
      newUser.apellidos = apellidos;
      newUser.salario = salario;
      newUser.telefono = telefono;
      newUser.cargo = cargo;
      newUser.idNegocio = idNegocio;
      print(emailController.text);
    _signUp(email, password);
  }

  void _showPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _signUp(String email, String password) {
    _authDataSource.signUpWithEmail(email, password).then((id) => {
      if(id != null){
        _showToast("Sign up: " + id.toString()),
        newUser.id = id,
        _addUser()
      }
    });
  }

  void _addUser() {
    _userDataSource.addUser(newUser).then((value) => {
      _showToast("Add user: " + value.toString()),
    });
  }

  void _signIn(String email, String password) {
    _authDataSource.signInWithEmail(email, password).then((id) => {
      _showToast("Sign in: " + id.toString()),
        });
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
