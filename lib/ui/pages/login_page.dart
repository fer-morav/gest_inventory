import 'dart:async';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/bloc/AuthCubit.dart';
import 'package:gest_inventory/ui/components/DialogResetPassword.dart';
import 'package:gest_inventory/ui/components/IconButton.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import 'package:gest_inventory/utils/custom_toast.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/resources.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/colors.dart';
import '../components/HeaderPaintComponent.dart';
import '../components/TextInputForm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorEmail;

  bool _show = true;
  bool _enableButton = false;
  bool isLoading = true;

  final _padding = const EdgeInsets.only(
    left: 20,
    right: 20,
    bottom: 5,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: HeaderPaintDiagonal(),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    child: Image.asset(image_logo_blanco_png),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: primaryOnColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
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
                          inputAction: TextInputAction.done,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: _padding,
                          child: TextButton(
                            onPressed: _showDialogResetPassword,
                            child: Text(
                              text_forget_password,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        state == AuthState.signIn
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 50,
                                width: double.infinity,
                                child: ButtonIcon(
                                  isEnable: _enableButton,
                                  onPressed: _signIn,
                                  text: button_login,
                                  icon: AppIcons.login,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 30),
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
                            context.read<AuthCubit>().setState(AuthState.signUp);
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
          ),
        );
      }),
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

  Future<void> _signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? result = await BlocProvider.of<AuthCubit>(context)
        .signInWithEmail(email, password);

    if (result == null || result.isEmpty) {
      CustomToast.showToast(
        message: alert_content_not_valid_data,
        context: context,
        status: false,
      );
      return;
    }
  }

  void _showDialogResetPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DialogResetPassword(
          emailController: TextEditingController(),
        );
      },
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
