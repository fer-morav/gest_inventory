import 'dart:async';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/MainButton.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/custom_toast.dart';
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
  final _padding = const EdgeInsets.only(
    left: 20,
    top: 5,
    right: 20,
    bottom: 5,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _errorEmail;

  bool _show = true;
  bool _enableButton = false;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: isLoading
          ? _showProgressIndicator()
          : Scaffold(
              appBar: AppBarComponent(
                textAppBar: title_login_user,
              ),
              body: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30,
                      top: 5,
                      right: 30,
                      bottom: 10,
                    ),
                    child: Image.asset(image_logo_azul_png),
                  ),
                  TextInputForm(
                    hintText: textfield_hint_email,
                    labelText: textfield_label_email,
                    controller: _emailController,
                    onTap: () {},
                    onChange: (content) => _onChangeEmail(content),
                    inputType: TextInputType.emailAddress,
                    errorText: _errorEmail,
                    inputAction: TextInputAction.next,
                  ),
                  TextInputForm(
                    hintText: textfield_hint_password,
                    labelText: textfield_label_password,
                    controller: _passwordController,
                    inputType: TextInputType.visiblePassword,
                    passwordTextStatus: _show,
                    onTap: _showPassword,
                    onChange: (content) => _onChangePassword(),
                  ),
                  Container(
                    padding: _padding,
                    height: 70,
                    child: MainButton(
                      isEnable: _enableButton,
                      onPressed: _signIn,
                      text: button_login,
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
                    padding: const EdgeInsets.only(left: 30, right: 30),
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
                          child: Text(
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

  void _showPassword() {
    setState(() {
      _show = !_show;
    });
  }

  void _onChangeEmail(String email) {
    _errorEmail = null;

    if (email.isEmpty) {
      _errorEmail = textfield_error_email_empty;
    } else if (!EmailValidator.validate(email)) {
      _errorEmail = textfield_error_email;
    }

    _enableButton = isValidForm();
    setState(() {});
  }

  void _onChangePassword() {
    setState(() {
      _enableButton = isValidForm();
    });
  }

  bool isValidForm() {
    return _emailController.text.trim().isEmailValid() &&
        _passwordController.text.trim().isPasswordValid();
  }

  void _checkLogin() async {
    String? userId = _authDataSource.getUserId();

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

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        _authDataSource.signInWithEmail(email, password),
      ),
    );

    if (result == null || result.isEmpty) {
      CustomToast.showToast(message: alert_content_not_valid_data, context: context, status: false);
      return;
    }

    User? user = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        _userDataSource.getUser(result),
      ),
    );

    if (user == null) {
      await showOkAlertDialog(
        context: context,
        title: alert_title_error_general,
        message: alert_content_error_general,
        barrierDismissible: false,
        okLabel: button_accept,
      );
      return;
    }

    if (user.cargo == "[Empleado]") {
      _nextScreen(employees_route, user);
    } else if (user.cargo == "[Administrador]") {
      _nextScreen(administrator_route, user);
    }
  }

  void _showDialogResetPassword(BuildContext context) {
    final emailController = new TextEditingController();
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
                    height: 60,
                    child: MainButton(
                      onPressed: () {
                        _sendEmailResetPassword(emailController.text);
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

  Future<void> _sendEmailResetPassword(String email) async {
    if (email.isNotEmpty) {
      bool result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          _authDataSource.sendPasswordResetEmail(email),
        ),
      );

      if (result) {
        CustomToast.showToast(message: alert_title_send_email, context: context);
      } else {
        CustomToast.showToast(message: alert_title_error_not_registered, context: context, status: false);
      }

      Navigator.of(context).pop();
    }
  }

  void _nextScreen(String route, User user) {
    final args = {user_args: user};
    Navigator.popAndPushNamed(context, route, arguments: args);
  }

  Scaffold _showProgressIndicator() {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 5,
          ),
          width: 75,
          height: 75,
        ),
      ),
    );
  }
}
