import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/resources.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/data/firebase/FirebaseAuthDataSource.dart';
import '../components/TextInputForm.dart';
import '../data/firebase/FirebaseUserDataSource.dart';
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
  late final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();

  bool showPassword = true;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
        body: isLoading
            ? waitingConnection()
            : ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30,
                      top: 10,
                      right: 30,
                      bottom: 10,
                    ),
                    child: Image.asset(image_logo_azul_png),
                  ),
                  TextInputForm(
                    hintText: textfield_hint_email,
                    labelText: textfield_label_email,
                    controller: emailController,
                    onTap: () {},
                    inputType: TextInputType.emailAddress,
                  ),
                  TextInputForm(
                    hintText: textfield_hint_password,
                    labelText: textfield_label_password,
                    controller: passwordController,
                    inputType: TextInputType.visiblePassword,
                    passwordTextStatus: showPassword,
                    onTap: _showPassword,
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
                    padding: _padding,
                    child: TextButton(
                      onPressed: () {
                        _showDialogResetPassword(context);
                      },
                      child: Text(
                        text_forget_password,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 30, top: 0, right: 30, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          text_havent_business,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, register_user_route);
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
    String email = emailController.text.split(" ").first;
    String password = passwordController.text.split(" ").first;

    if (email.isEmpty && password.isEmpty) {
      _showToast(alert_content_imcomplete);
    } else {
      if (email.isEmpty) {
        _showToast(alert_content_email);
      } else {
        if (password.isEmpty) {
          _showToast(alert_content_password);
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
        .signInWithEmail(emailController.text.split(" ").first,
            passwordController.text.split(" ").first)
        .then((id) async => {
              _userId = id,
              if (_userId == null)
                {
                  _showToast(alert_content_not_valid_data),
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
                      _nextScreen(employees_route, newUser)
                    }
                  else
                    {
                      if (newUser.cargo == "[Administrador]")
                        {_nextScreen(administrator_route, newUser)}
                    }
                }
            });
    return _userId;
  }

  void _showDialogResetPassword(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title_reset_password,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          content: TextInputForm(
            hintText: textfield_hint_email,
            labelText: textfield_label_email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
            onTap: () {},
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      button_cancel,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ButtonSecond(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _sendEmailResetPassword(emailController);
                      },
                      text: button_recover_password,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _sendEmailResetPassword(TextEditingController emailController) {
    if (emailController.text.isNotEmpty) {
      _authDataSource.sendPasswordResetEmail(emailController.text).then(
          (value) => value
              ? _showToast(alert_title_send_email)
              : _showToast(alert_title_error_not_registered));
    } else {
      _showToast(alert_content_email);
    }
  }

  void _checkLogin() async {
    String? userId;
    userId = _authDataSource.getUserId();

    if (userId != null) {
      User? user = await _userDataSource.getUser(userId);
      if (user != null) {
        if (user.cargo == "[Empleado]") {
          _nextScreen(employees_route, user);
        } else {
          _nextScreen(administrator_route, user);
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextScreen(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
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

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }
}
