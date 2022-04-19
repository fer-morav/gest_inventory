import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({Key? key}) : super(key: key);

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  TextEditingController idController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController salarioController = TextEditingController();

  String? _idError;
  String? _nombreError;
  String? _apellidosError;
  String? _telefonoError;
  String? _salarioError;
  String? _cargoError;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseUserDataSource _userDataSource = FirebaseUserDataSource();

  bool _isLoading = true;
  User? _user;

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
        textAppBar: title_modify_profile,
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
                    hintText: textfield_label_name,
                    labelText: textfield_label_name,
                    textEditingController: nombreController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _nombreError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: textfield_label_last_name,
                    labelText: textfield_label_last_name,
                    textEditingController: apellidosController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _apellidosError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: textfield_label_number_phone,
                    labelText: textfield_label_number_phone,
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
                  child: TextFieldMain(
                    hintText: textfield_label_salary,
                    labelText: textfield_label_salary,
                    textEditingController: salarioController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    isNumber: true,
                    errorText: _salarioError,
                  ),
                ),
                Container(
                  padding: _padding,
                  child: MultiSelect(
                      cancelButtonText: button_cancel,
                      saveButtonText: button_save,
                      clearButtonText: button_reset,
                      titleText: title_roles,
                      checkBoxColor: Colors.blue,
                      selectedOptionsInfoText: "",
                      hintText: textfield_label_cargo,
                      maxLength: 1,
                      dataSource: const [
                        {"cargo": title_employees, "code": title_employees},
                        {"cargo": title_administrator, "code": title_administrator},
                      ],
                      textField: 'cargo',
                      valueField: 'code',
                      filterable: true,
                      required: true,
                      errorText: _cargoError,
                      onSaved: (value) {
                        cargoController.text = value.toString();
                      }),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () =>
          _showAlertDialog(context),
        child: Icon(Icons.person_remove),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Aceptar"),
      onPressed:  () {
        Navigator.of(context).pop();
        _showDialog(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("ALERTA"),
      content: Text("¿Desea eliminar al usuario?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed:  () {
        Navigator.of(context).pop();
        _userDataSource.deleteUser(_user!.id.toString());
        _nextScreen(administrator_route, _user!);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("ELIMINACION EXITOSA"),
      content: Text("Empleado eliminado"),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _user = args[user_args];

    idController.text = _user!.id;
    nombreController.text = _user!.nombre;
    apellidosController.text = _user!.apellidos;
    cargoController.text = _user!.cargo;
    telefonoController.text = _user!.telefono.toString();
    salarioController.text = _user!.salario.toString();

    setState(() {
      _isLoading = false;
    });
  }

  void _saveData() async {
    _nombreError = null;
    _apellidosError = null;
    _telefonoError = null;
    _salarioError = null;
    _cargoError = null;

    if (nombreController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre no puede quedar vacío";
      });

      return;
    }

    if (apellidosController.text.isEmpty) {
      setState(() {
        _apellidosError = "El apellido no puede quedar vacío";
      });

      return;
    }

    if (salarioController.text.isEmpty) {
      setState(() {
        _salarioError = "El salario no puede quedar vacío";
      });

      return;
    }

    if (telefonoController.text.isEmpty) {
      setState(() {
        _telefonoError = "El telefono no puede quedar vacío";
      });

      return;
    }

    if (cargoController.text.isEmpty) {
      setState(() {
        _cargoError = "El cargo no puede quedar vacío";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _user?.nombre = nombreController.text;
    _user?.apellidos = apellidosController.text;
    _user?.telefono = int.parse(telefonoController.text);
    _user?.salario = double.parse(salarioController.text);
    _user?.cargo = cargoController.text;

    if(_user != null && await _userDataSource.updateUser(_user!)) {
      _showToast("Datos actualizados");
      _nextScreenArgs(info_business_route, _user!.idNegocio);
    } else {
      _showToast("Error al actualizar los datos");
    }
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
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

  void _nextScreen(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
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
