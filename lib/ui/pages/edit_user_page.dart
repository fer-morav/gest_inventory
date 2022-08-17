import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/domain/bloc/firebase/UserCubit.dart';
import 'package:gest_inventory/ui/components/ButtonSecond.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/datasource/firebase/FirebaseUserDataSource.dart';
import '../../data/models/User.dart';
import '../../utils/colors.dart';
import '../../utils/custom_toast.dart';
import '../components/AppBarComponent.dart';
import '../components/TextInputForm.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _idController = TextEditingController();
  final _positionController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();

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

  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                TextInputForm(
                  hintText: textfield_label_name,
                  labelText: textfield_label_name,
                  controller: _nameController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _nombreError,
                ),
                TextInputForm(
                  hintText: textfield_label_last_name,
                  labelText: textfield_label_last_name,
                  controller: _lastnameController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _apellidosError,
                ),
                TextInputForm(
                  hintText: textfield_label_number_phone,
                  labelText: textfield_label_number_phone,
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  onTap: () {},
                  errorText: _telefonoError,
                ),
                TextInputForm(
                  hintText: textfield_label_salary,
                  labelText: textfield_label_salary,
                  controller: _salaryController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _salarioError,
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
                        _positionController.text = value.toString();
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
      child: Text(button_accept),
      onPressed:  () {
        Navigator.of(context).pop();
        _showDialog(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(button_cancel),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(alert_title.toUpperCase()),
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
      child: Text(button_accept),
      onPressed:  () {
        Navigator.of(context).pop();
        BlocProvider.of<UserCubit>(context).deleteUser(_user!.id.toString());
        _nextScreen(administrator_route, _user!);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(text_successful_delete.toUpperCase()),
      content: Text(text_employee_delete),
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

    _idController.text = _user!.id;
    _nameController.text = _user!.nombre;
    _lastnameController.text = _user!.apellidos;
    _positionController.text = _user!.cargo;
    _phoneController.text = _user!.telefono.toString();
    _salaryController.text = _user!.salario.toString();

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

    if (_nameController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre no puede quedar vacío";
      });

      return;
    }

    if (_lastnameController.text.isEmpty) {
      setState(() {
        _apellidosError = "El apellido no puede quedar vacío";
      });

      return;
    }

    if (_salaryController.text.isEmpty) {
      setState(() {
        _salarioError = "El salario no puede quedar vacío";
      });

      return;
    }

    if (_phoneController.text.isEmpty) {
      setState(() {
        _telefonoError = "El telefono no puede quedar vacío";
      });

      return;
    }

    if (_positionController.text.isEmpty) {
      setState(() {
        _cargoError = "El cargo no puede quedar vacío";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _user?.nombre = _nameController.text;
    _user?.apellidos = _lastnameController.text;
    _user?.telefono = int.parse(_phoneController.text);
    _user?.salario = double.parse(_salaryController.text);
    _user?.cargo = _positionController.text;

    if(_user != null && await BlocProvider.of<UserCubit>(context).updateUser(_user!)) {
      _showToast(text_update_data, true);
      _nextScreenArgs(info_business_route, _user!.idNegocio);
    } else {
      _showToast(text_error_update_data, false);
    }
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }

  void _nextScreen(String route, User user) {
    final args = {user_args: user};
    Navigator.popAndPushNamed(context, route, arguments: args);
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
