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

class DelNegPage extends StatefulWidget {
  const DelNegPage({Key? key}) : super(key: key);

  @override
  State<DelNegPage> createState() => _DelNegPageState();
}

class _DelNegPageState extends State<DelNegPage> {
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
              height: 100,
              child: const Text.rich(
                TextSpan(
                  text: "¿Está Segur@ de Eliminar el Negocio Completamente?",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Color.fromARGB(1000, 0, 68, 106),
                  ),
                ),
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: _delBusiness,
                text: "Si, Eliminar todo.",
                isDisabled: false,
              ),
            ),
            Container(
              padding: _padding,
              height: 80,
              child: ButtonMain(
                onPressed: () => _nextScreen(info_neg_route),
                text: "No, Cancelar.",
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

  void _delBusiness(){

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
