import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextInputForm.dart';
import 'package:gest_inventory/data/firebase/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../data/firebase/FirebaseBusinessDataSource.dart';
import '../data/firebase/FirebaseUserDataSource.dart';
import '../data/models/Business.dart';
import '../data/models/User.dart';

class AddBusinessPage extends StatefulWidget {
  const AddBusinessPage({Key? key}) : super(key: key);

  @override
  State<AddBusinessPage> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusinessPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  Business newBusiness = Business(
    id: "",
    nombreNegocio: "",
    idDueno: "",
    nombreDueno: "",
    direccion: "",
    correo: "",
    telefono: 0,
    activo: false,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();
  late final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();

  User? user;
  String? userId;

  TextEditingController negocioController = TextEditingController();
  TextEditingController propietarioController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    negocioController.dispose();
    propietarioController.dispose();
    direccionController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_add_business,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          TextInputForm(
            hintText: textfield_hint_name,
            labelText: textfield_label_name,
            controller: negocioController,
            inputType: TextInputType.name,
            passwordTextStatus: false,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_email,
            labelText: textfield_label_email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_name_owner,
            labelText: textfield_label_owner,
            controller: propietarioController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_address,
            labelText: textfield_label_address,
            controller: direccionController,
            inputType: TextInputType.streetAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_phone,
            labelText: textfield_label_number_phone,
            controller: telefonoController,
            inputType: TextInputType.phone,
            onTap: () {},
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: _saveDataBusiness,
              text: button_add_business,
              isDisabled: false,
            ),
          ),
        ],
      ),
    );
  }

  void _addBusiness() {
    if (userId != null) {
      _userDataSource.getUser(userId!).then((user) => {
            if (user != null)
              {
                _businessDataSource
                    .addBusiness(newBusiness)
                    .then((negocioId) => {
                          _showToast("Add bussiness: " + negocioId.toString()),
                          if (negocioId != null)
                            {
                              user.idNegocio = negocioId,

                              _userDataSource.updateUser(user).then(
                                    (value) => _nextScreenArgs(administrator_route, user),
                                  )
                            }
                        }),
              }
          });
    }
  }

  void _nextScreenArgs(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _saveDataBusiness() {
    userId = _authDataSource.getUserId();
    if (negocioController.text.isNotEmpty &&
        propietarioController.text.isNotEmpty &&
        direccionController.text.isNotEmpty &&
        telefonoController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      newBusiness.nombreNegocio = negocioController.text;
      newBusiness.nombreDueno = propietarioController.text;
      newBusiness.idDueno = userId!;
      newBusiness.direccion = direccionController.text;
      newBusiness.telefono = int.parse(telefonoController.text);
      newBusiness.correo = emailController.text;
      newBusiness.activo = true;
      _addBusiness();
    } else {
      _showToast("Informacion Incompleta");
    }
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
