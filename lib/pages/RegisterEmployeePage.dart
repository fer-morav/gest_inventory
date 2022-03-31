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

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({Key? key}) : super(key: key);

  @override
  State<RegisterEmployeePage> createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idNegocioController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController salarioController = TextEditingController();
  TextEditingController cargoController = TextEditingController();

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
            child: TextFieldMain(
              hintText: textfield_hint_name,
              labelText: textfield_label_name,
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
              hintText: textfield_hint_last_name,
              labelText: textfield_label_last_name,
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
              hintText: textfield_hint_phone,
              labelText: textfield_label_number_phone,
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
              hintText: textfield_hint_salary,
              labelText: textfield_label_salary,
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
                hintText: textfield_label_cargo,
                maxLength: 1,
                maxLengthText: textfield_hint_one_option,
                dataSource: const [
                  {"cargo": title_employees, "code": title_employees},
                  {"cargo": title_administrator, "code": title_administrator},
                ],
                textField: "cargo",
                valueField: "code",
                hintTextColor: primaryColor,
                enabledBorderColor: primaryColor,
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
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nombreController.text.isNotEmpty &&
        apellidosController.text.isNotEmpty &&
        salarioController.text.isNotEmpty &&
        telefonoController.text.isNotEmpty &&
        cargoController.text.isNotEmpty) {
      newUser.nombre = nombreController.text;
      newUser.apellidos = apellidosController.text;
      newUser.salario = double.parse(salarioController.text);
      newUser.telefono = int.parse(telefonoController.text);
      newUser.cargo = cargoController.text;
      _signUp(emailController.text, passwordController.text);
    } else {
      _showToast("Informacion Incompleta");
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
        }else{
        _showToast("No lo registra")
      }
    });
  }

  void _addUser() {
    _userDataSource.addUser(newUser).then((value) => {
      _showToast("Add user: " + value.toString()),
      if (value)
        {
          _nextScreen(administrator_route),
        }
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
