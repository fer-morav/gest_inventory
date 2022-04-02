import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import '../data/models/User.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({Key? key}) : super(key: key);

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  TextEditingController idNegocioController = TextEditingController();
  TextEditingController cargoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController salarioController = TextEditingController();

  String? _idNegocioError;
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

  late final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  late final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();

  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getUser();
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
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: textfield_label_id_business,
                    labelText: textfield_label_id_business,
                    textEditingController: idNegocioController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {},
                    errorText: _idNegocioError,
                  ),
                ),
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
                  child: ButtonMain(
                    onPressed: _saveData,
                    text: button_save,
                    isDisabled: true,
                  ),
                ),
              ],
            ),
    );
  }

  void _getUser() async {
    String? userId = _authDataSource.getUserId();

    if (userId == null) {
      Navigator.pop(context);
      return;
    }

    User? user = await _userDataSource.getUser(userId);

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    _user = user;

    idNegocioController.text = user.idNegocio;
    nombreController.text = user.nombre;
    apellidosController.text = user.apellidos;
    cargoController.text = user.cargo;
    telefonoController.text = user.telefono.toString();
    salarioController.text = user.salario.toString();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    _idNegocioError = null;
    _nombreError = null;
    _apellidosError = null;
    _telefonoError = null;
    _salarioError = null;
    _cargoError = null;

    if (idNegocioController.text.isEmpty) {
      setState(() {
        _idNegocioError = "El ID del negocio no puede quedar vacío";
      });

      return;
    }

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

    _user?.idNegocio = idNegocioController.text;
    _user?.nombre = nombreController.text;
    _user?.apellidos = apellidosController.text;
    _user?.telefono = int.parse(telefonoController.text);
    _user?.salario = double.parse(salarioController.text);
    _user?.cargo = cargoController.text;

    if(_user != null && await _userDataSource.updateUser(_user!)) {
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
}
