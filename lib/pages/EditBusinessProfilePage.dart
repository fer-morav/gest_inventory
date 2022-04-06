import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import '../data/models/User.dart';

class EditBusinessProfilePage extends StatefulWidget {
  const EditBusinessProfilePage({Key? key}) : super(key: key);

  @override
  State<EditBusinessProfilePage> createState() => _EditBusinessProfilePageState();
}

class _EditBusinessProfilePageState extends State<EditBusinessProfilePage> {
  TextEditingController nombreNegocioController = TextEditingController();
  TextEditingController nombreDuenoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController activoController = TextEditingController();

  String? business;
  String? _nombreNegocioError;
  String? _nombreDuenoError;
  String? _direccionError;
  String? _correoError;
  String? _telefonoError;
  String? _activoError;

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
        textAppBar: "Modificar Negocio",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Nombre del Negocio",
                    labelText: "Nombre del Negocio",
                    textEditingController: nombreNegocioController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _nombreNegocioError,
                  ),
                ),Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Nombre del Dueño",
                    labelText: "Nombre del Dueño",
                    textEditingController: nombreDuenoController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _nombreDuenoError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Dirección del Negocio",
                    labelText: "Dirección del Negocio",
                    textEditingController: direccionController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _direccionError,
                  ),
                ),Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Correo del Negocio",
                    labelText: "Correo del Negocio",
                    textEditingController: correoController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _correoError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Telefono del Negocio",
                    labelText: "Telefono del Negocio",
                    textEditingController: telefonoController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _telefonoError,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed: _saveData,
                    text: button_save,
                  ),
                ),
              ],
            ),
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _business = args["args"];

    nombreNegocioController.text = _business!.nombreNegocio;
    nombreDuenoController.text = _business!.nombreDueno;
    direccionController.text = _business!.direccion;
    correoController.text = _business!.correo;
    telefonoController.text = _business!.telefono.toString();
    activoController.text = _business!.activo.toString();

    setState(() {
      _isLoading = false;
    });
  }

  void _saveData() async {
    _nombreNegocioError = null;
    _nombreDuenoError = null;
    _direccionError = null;
    _correoError = null;
    _telefonoError = null;
    _activoError = null;

    if (nombreNegocioController.text.isEmpty) {
      setState(() {
        _nombreNegocioError = "El nombre del negocio no puede quedar vacío";
      });

      return;
    }

    if (nombreDuenoController.text.isEmpty) {
      setState(() {
        _nombreDuenoError = "El nombre del dueño no puede quedar vacío";
      });

      return;
    }

    if (direccionController.text.isEmpty) {
      setState(() {
        _direccionError = "La dirección no puede quedar vacía";
      });

      return;
    }

    if (correoController.text.isEmpty) {
      setState(() {
        _correoError = "El correo no puede quedar vacía";
      });

      return;
    }

    if (telefonoController.text.isEmpty) {
      setState(() {
        _telefonoError = "El telefono no puede quedar vacío";
      });

      return;
    }

    /*if (activoController.text.isEmpty) {
      setState(() {
        _activoError = "El estado no puede quedar vacío";
      });

      return;
    }*/

    setState(() {
      _isLoading = true;
    });

    _business?.nombreNegocio = nombreNegocioController.text;
    _business?.nombreDueno = nombreDuenoController.text;
    _business?.direccion = direccionController.text;
    _business?.correo = correoController.text;
    _business?.telefono = int.parse(telefonoController.text);
    //_business?.activo = activoController.text as bool;

    if(_business != null && await _businessDataSource.updateBusiness(_business!)) {
      _showToast("Datos actualizados");
      Navigator.pop(context);
    } else {
      _showToast("Error al actualizar los datos");
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
