import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextInputForm.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../data/firebase/FirebaseAuthDataSource.dart';
import '../data/firebase/FirebaseUserDataSource.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
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
  late final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();

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
          SizedBox(
            height: 10,
            width: double.infinity,
          ),
          TextInputForm(
            hintText: textfield_hint_email,
            labelText: textfield_label_email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_password,
            labelText: textfield_label_password,
            controller: passwordController,
            inputType: TextInputType.visiblePassword,
            passwordTextStatus: showPassword,
            onTap: _showPassword,
          ),
          TextInputForm(
            hintText: textfield_hint_name,
            labelText: textfield_label_name,
            controller: nombreController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_last_name,
            labelText: textfield_label_last_name,
            controller: apellidosController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_phone,
            labelText: textfield_label_number_phone,
            controller: telefonoController,
            inputType: TextInputType.phone,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_salary,
            labelText: textfield_label_salary,
            controller: salarioController,
            inputType: TextInputType.number,
            onTap: () {},
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
        telefonoController.text.isNotEmpty) {
      newUser.nombre = nombreController.text;
      newUser.apellidos = apellidosController.text;
      newUser.salario = double.parse(salarioController.text);
      newUser.telefono = int.parse(telefonoController.text);
      newUser.cargo = "[Administrador]";
      _signUp(emailController.text.split(" ").first, passwordController.text.split(" ").first);
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
            }
        });
  }

  void _addUser() {
    _userDataSource.addUser(newUser).then((value) => {
          _showToast("Add user: " + value.toString()),
          if (value)
            {
              _nextScreen(add_business_route),
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
