import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/TextFieldMain.dart';
import 'package:gest_inventory/data/framework/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
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
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();

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
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: textfield_hint_name,
              labelText: textfield_label_name,
              textEditingController: negocioController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
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
              hintText: textfield_hint_name_owner,
              labelText: textfield_label_owner,
              textEditingController: propietarioController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: TextFieldMain(
              hintText: textfield_hint_address,
              labelText: textfield_label_address,
              textEditingController: direccionController,
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
                                    (value) => _nextScreenArgs(administrator_route, negocioId),
                                  )
                            }
                        }),
              }
          });
    }
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {"args": businessId};
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
