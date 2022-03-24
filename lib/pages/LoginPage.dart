import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextFieldMain.dart';
import 'package:gest_inventory/pages/AdministratorPage.dart';
import 'package:gest_inventory/pages/EmployeesPage.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        textAppBar: title_register_user,
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
            child: ButtonMain(
              onPressed: _loginUser,
              text: button_login_accept,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty &&
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ingrese correo y contraseña válidos"),
      ));
    } else {
      if(email.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ingrese un correo electrónico válido"),
        ));
      }else{
        if(password.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ingrese una contraseña válida"),
          ));
        }else{
          _signIn();
        }
      }
    }
  }

  void _showPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  String? _signIn() {
    /* Los siguientes valores seran remplazados por los datos de email y
    * contraseña capturados del usuario, si el usuario ya registro sus
    * credenciales podra iniciar sesion sin problemas*/

    String? _userId;
    _authDataSource.signInWithEmail(emailController.text, passwordController.text).then((id) async =>
    {_userId = id,
      if(_userId == null){
        _showToast("Correo o contraseña invalidos"),
      }else{
        //Se obtiene los datos del usuario
        newUser = (await _userDataSource.getUser(_userId!))! ,
        _showToast("Bienvenido "+ newUser.cargo +" "+ newUser.nombre),
        //Envio a interfaces
        if(newUser.cargo == "[Empleado]" ){
          //Ingresar interfaz de empleado
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeesPage()))
        }else{
          if(newUser.cargo == "[Administrador]"){
            //Ingresar interfaz de Administrador
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdministratorPage()))
          }
        }
      }
    });
    return _userId;
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
