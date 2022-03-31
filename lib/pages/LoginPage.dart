import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextFieldMain.dart';
import 'package:gest_inventory/utils/resources.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';

import '../utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  void initState(){
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      _checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_login_user,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              child: Image.asset(image_logo_azul_png),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextFieldMain(
                hintText: textfield_hint_email,
                labelText: textfield_label_email,
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
                hintText: textfield_hint_password,
                labelText: textfield_label_password,
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
                text: button_login,
                isDisabled: true,
              ),
            ),
            Container(
              padding:
              const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    text_havent_account,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _nextScreen(register_user_route);
                    },
                    child: const Text(
                      button_registry,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ingrese correo y contraseña válidos"),
      ));
    } else {
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ingrese un correo electrónico válido"),
        ));
      } else {
        if (password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ingrese una contraseña válida"),
          ));
        } else {
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
    String? _userId;
    _authDataSource
        .signInWithEmail(emailController.text, passwordController.text)
        .then((id) async => {
              _userId = id,
              if (_userId == null)
                {
                  _showToast("Correo o contraseña invalidos"),
                }
              else
                {
                  //Se obtiene los datos del usuario
                  newUser = (await _userDataSource.getUser(_userId!))!,
                  _showToast(
                      "Bienvenido " + newUser.cargo + " " + newUser.nombre),
                  //Envio a interfaces
                  if (newUser.cargo == "[Empleado]")
                    {
                      //Ingresar interfaz de empleado
                      _nextScreen(employees_route)
                    }
                  else
                    {
                      if (newUser.cargo == "[Administrador]")
                        {
                          _nextScreen(administrator_route)
                        }
                    }
                }
            });
    return _userId;
  }

  void _checkLogin() async {
    String? userId;
    userId = _authDataSource.getUserId();

    if(userId != null) {
      User? user = await _userDataSource.getUser(userId);
      if (user != null) {
        if(user.cargo == "[Empleado]"){
          _nextScreen(employees_route);
        }else{
          _nextScreen(administrator_route);
        }
      }
    }
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
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
