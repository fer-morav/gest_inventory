import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String nombre, apellidos, cargo, salario, telefono, idNegocio, negocio;
  String? userPosition;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

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
        textAppBar: title_info_user,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(
                    left: 100,
                    top: 10,
                    right: 100,
                    bottom: 10,
                  ),
                  child: Transform.scale(
                    scale: 5,
                    child: Icon(
                      Icons.account_circle,
                      color: cargo == "[Administrador]"
                          ? Colors.redAccent
                          : Colors.greenAccent,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 80,
                    top: 10,
                    right: 80,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cargo == "[Administrador]"
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FittedBox(
                    child: Text(
                      cargo == "[Administrador]" ? "Administrador" : "Empleado",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Negocio: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    negocio,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Nombre: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    nombre + " " + apellidos,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Teléfono: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    telefono,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Salario:",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "\$ " + salario,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () => _nextScreenArgs(modify_profile_route, _user!),
          backgroundColor: primaryColor,
          child: Icon(Icons.edit_outlined),
        ),
        visible: userPosition == "[Administrador]" ? true : false,
      ),
    );
  }

  void _nextScreenArgs(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _user = args[user_args];
    userPosition = args[user_position_args];

    nombre = _user!.nombre;
    apellidos = _user!.apellidos;
    cargo = _user!.cargo;
    telefono = _user!.telefono.toString();
    salario = _user!.salario.toString();
    idNegocio = _user!.idNegocio.toString();

    _businessDataSource.getBusiness(idNegocio).then((business) => {
          if (business != null)
            {
              setState(() {
                _business = business;
                negocio = _business!.nombreNegocio.toString();
                _isLoading = false;
              }),
            }
          else
            {print(business?.id)}
        });
  }

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }
}
