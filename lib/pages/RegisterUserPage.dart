import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextFieldMain.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
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
              hintText: textfield_email,
              labelText: textfield_email,
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
              hintText: textfield_password,
              labelText: textfield_password,
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
              hintText: textfield_id_bussiness,
              labelText: textfield_id_bussiness,
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
              hintText: textfield_name,
              labelText: textfield_name,
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
              hintText: textfield_last_name,
              labelText: textfield_last_name,
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
              hintText: textfield_number_phone,
              labelText: textfield_number_phone,
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
              hintText: textfield_salary,
              labelText: textfield_salary,
              textEditingController: salarioController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              isNumber: true,
            ),
          ),
          Container(
            padding: _padding,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MultiSelect(
                cancelButtonText: button_cancel,
                saveButtonText: button_save,
                clearButtonText: button_reset,
                titleText: title_roles,
                checkBoxColor: Colors.blue,
                selectedOptionsInfoText: "",
                hintText: textfield_cargo,
                maxLengthIndicatorColor: Colors.white,
                dataSource: const [
                  {
                    textfield_cargo: button_login_help,
                    "code": button_login_help
                  },
                  {
                    textfield_cargo: title_administrator,
                    "code": title_administrator
                  },
                ],
                textField: textfield_cargo,
                enabledBorderColor: primaryColor,
                hintTextColor: primaryColor,
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
              onPressed: _registerUser,
              text: button_register_user,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _registerUser() {
    String email = emailController.text;
    String password = passwordController.text;
    String nombre = nombreController.text;
    String apellidos = apellidosController.text;
    double salario = double.parse(salarioController.text);
    int telefono = int.parse(telefonoController.text);
    String cargo = cargoController.text;
    String idNegocio = idController.text;

    if (email.isEmpty &&
        password.isEmpty &&
        nombre.isEmpty &&
        apellidos.isEmpty &&
        salarioController.text.isEmpty &&
        telefonoController.text.isEmpty &&
        cargo.isEmpty &&
        idNegocio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Informacion incompleta"),
        ),
      );
    } else {
      newUser.nombre = nombre;
      newUser.apellidos = apellidos;
      newUser.salario = salario;
      newUser.telefono = telefono;
      newUser.cargo = cargo;
      newUser.idNegocio = idNegocio;
      _signUp(email, password);
    }
  }

  void _showPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _signUp(String email, String password) {
    _authDataSource.signUpWithEmail(email, password).then((id) => {
          if (id != null)
            {
              _showToast("Sign up: " + id.toString()),
              newUser.id = id,
              _addUser()
            }
        });
  }

  void _addUser() {
    _userDataSource.addUser(newUser).then((value) => {
      _showToast("Add user: " + value.toString()),
      _nextScreen(login_route),
        });
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
