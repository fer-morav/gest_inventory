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

import '../data/models/User.dart';

class ModNegPage extends StatefulWidget {
  const ModNegPage({Key? key}) : super(key: key);

  @override
  State<ModNegPage> createState() => _ModNegPageState();
}

class _ModNegPageState extends State<ModNegPage> {
  final _padding = const EdgeInsets.only(
    left: 30,
    top: 10,
    right: 30,
    bottom: 10,
    
  );

  User ActUser = User(
    id: "",
    idNegocio: "",
    cargo: "",
    nombre: "",
    apellidos: "",
    telefono: 0,
    salario: 0.0,
  );

  Business NegUser = Business(
    id: "",
    nombreNegocio: "",
    nombreDueno: "",
    direccion: "",
    correo: "",
    telefono: 0,
    activo: true,
  );


  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  late String _userId, _negId,_active="NO";

  TextEditingController negocioController = TextEditingController();
  TextEditingController propietarioController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  
  
  void LoadData() {
    _userId = _authDataSource.getUserId()!;
    _userDataSource.getUser(_userId).then((user) => {if (user != Null) {
      ActUser = user!,
      _negId = ActUser.idNegocio,
      _businessDataSource.getBusiness(_negId).then((neg) => {if (neg != Null) {
        setState((){
          NegUser = neg!;
          if(NegUser.activo == true){
            _active="SI";
          }else{
            _active="NO";
          }
        })
      }}),
    }});
  }

  @override
  void initState(){
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      LoadData();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent(
          textAppBar: title_admin,//cambiar por el titulo de pantalla NegUser.nombreNegocio.toString()
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Container(
              padding: _padding,
              height: 80,
              child: const Text.rich(
                TextSpan(
                  text: subTitle_ModNego,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: TextFieldMain(
                hintText: textfield_hint_name,
                labelText: "Negocio: "+NegUser.nombreNegocio,
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
                labelText: "Email: "+NegUser.correo,
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
                labelText: "Propietario: "+NegUser.nombreDueno,
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
                labelText: "Dirección: "+NegUser.direccion,
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
                labelText: "Teléfono: "+NegUser.telefono.toString(),
                textEditingController: telefonoController,
                isPassword: false,
                isPasswordTextStatus: false,
                onTap: () {},
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: _saveDataBusiness,
                text: "Actualizar Información",
                isDisabled: false,
              ),
            ),
          ],
        ),
    );
  }
  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _saveDataBusiness() {
    if(negocioController.text.isEmpty){
      NegUser.nombreNegocio = NegUser.nombreNegocio;
    }else{
      NegUser.nombreNegocio = negocioController.text;
    }
    if(propietarioController.text.isEmpty){
      NegUser.nombreDueno = NegUser.nombreDueno;
    }else{
      NegUser.nombreDueno = propietarioController.text;
    }
    if(direccionController.text.isEmpty){
      NegUser.direccion = NegUser.direccion;
    }else{
      NegUser.direccion = direccionController.text;
    }
    if(telefonoController.text.isEmpty){
      NegUser.telefono = NegUser.telefono;
    }else{
      NegUser.telefono = int.parse(telefonoController.text);
    }
    if(emailController.text.isEmpty){
      NegUser.correo = NegUser.correo;
    }else{
      NegUser.correo = emailController.text;
    }
    NegUser.activo = true;
    _addBusiness();
  }

  void _addBusiness() {
    String? userId;
    userId = _authDataSource.getUserId();
    if (userId != null) {
      _userDataSource.getUser(userId).then((user) => {
            if (user != null)
              {
                _businessDataSource
                    .updateBusiness(NegUser)
                    .then((negocioId) => {
                          _showToast("Update bussiness: " + negocioId.toString()),
                          _userDataSource.updateUser(user).then(
                                    (value) => _nextScreen(info_neg_route),
                                  )
                        }),
              }
          });
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
