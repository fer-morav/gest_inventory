import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

class SeeInfoUserPage extends StatefulWidget {
  const SeeInfoUserPage({Key? key}) : super(key: key);

  @override
  State<SeeInfoUserPage> createState() => _SeeInfoUserPageState();
}

class _SeeInfoUserPageState extends State<SeeInfoUserPage> {

  String? _nombreError;
  String? _apellidosError;
  String? _telefonoError;
  String? _salarioError;
  String? _cargoError;
  late String nombre, apellidos, cargo, salario, telefono, idnegocio, negocio="";

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();


  bool _isLoading = true;
  User? _user;
  Business? _business;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getArguments();
      //_getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Información del Usuario",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 100, top: 10, right: 100, bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cargo == "[Administrador]" ? Colors.redAccent : Colors.greenAccent, 
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    cargo == "[Administrador]" ? "Administrador" : "Empleado",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    "Nombre: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    nombre+" "+apellidos,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: cargo == "[Administrador]" ? Colors.redAccent : Colors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    "Teléfono: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    telefono,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: cargo == "[Administrador]" ? Colors.redAccent : Colors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    "Salario:",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: Text(
                    "\$ "+salario,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: cargo == "[Administrador]" ? Colors.redAccent : Colors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _nextScreenArgs(modify_profile_route,_user!),
        child: Icon(Icons.edit_outlined,color: cargo == "[Administrador]" ? Colors.redAccent : Colors.green,),
      ),
    );
  }

  void _nextScreenArgs(String route, User user) {
    final args = {"args": user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _user = args["args"];


    nombre = _user!.nombre;
    apellidos = _user!.apellidos;
    cargo = _user!.cargo;
    telefono = _user!.telefono.toString();
    salario = _user!.salario.toString();
    setState(() {
      _isLoading = false;
    });
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
