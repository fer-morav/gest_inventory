import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/domain/bloc/firebase/BusinessCubit.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../ui/components/ButtonSecond.dart';
import '../../utils/custom_toast.dart';
import '../components/AppBarComponent.dart';
import '../components/TextInputForm.dart';

class EditBusinessPage extends StatefulWidget {
  const EditBusinessPage({Key? key}) : super(key: key);

  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  final _nameBusinessController = TextEditingController();
  final _nameOwnerController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _activeController = TextEditingController();

  String? _nameBusinessError;
  String? _nameOwnerError;
  String? _addressError;
  String? _emailError;
  String? _phoneError;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  bool _isLoading = true;
  Business? _business;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_edit_business,
        appBarColor: primaryOnColor,
        textColor: primaryColor,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                SizedBox(height: 20),
                TextInputForm(
                  hintText: textfield_hint_name,
                  labelText: textfield_label_name_business,
                  controller: _nameBusinessController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _nameBusinessError,
                ),
                TextInputForm(
                  hintText: textfield_hint_name,
                  labelText: textfield_label_owner,
                  controller: _nameOwnerController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _nameOwnerError,
                ),
                TextInputForm(
                  hintText: textfield_hint_address,
                  labelText: textfield_label_address,
                  controller: _addressController,
                  inputType: TextInputType.streetAddress,
                  onTap: () {},
                  errorText: _addressError,
                ),
                TextInputForm(
                  hintText: textfield_hint_email,
                  labelText: textfield_label_email,
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  onTap: () {},
                  errorText: _emailError,
                ),
                TextInputForm(
                  hintText: textfield_hint_phone,
                  labelText: textfield_label_number_phone,
                  controller: _phoneController,
                  inputType: TextInputType.phone,
                  onTap: () {},
                  errorText: _phoneError,
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

    _business = args[business_args];

    _nameBusinessController.text = _business!.nombreNegocio;
    _nameOwnerController.text = _business!.nombreDueno;
    _addressController.text = _business!.direccion;
    _emailController.text = _business!.correo;
    _phoneController.text = _business!.telefono.toString();
    _activeController.text = _business!.activo.toString();

    setState(() {
      _isLoading = false;
    });
  }

  void _saveData() async {
    _nameBusinessError = null;
    _nameOwnerError = null;
    _addressError = null;
    _emailError = null;
    _phoneError = null;

    if (_nameBusinessController.text.isEmpty) {
      setState(() {
        _nameBusinessError = "El nombre del negocio no puede quedar vacío";
      });

      return;
    }

    if (_nameOwnerController.text.isEmpty) {
      setState(() {
        _nameOwnerError = "El nombre del dueño no puede quedar vacío";
      });

      return;
    }

    if (_addressController.text.isEmpty) {
      setState(() {
        _addressError = "La dirección no puede quedar vacía";
      });

      return;
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = "El correo no puede quedar vacía";
      });

      return;
    }

    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = "El telefono no puede quedar vacío";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _business?.nombreNegocio = _nameBusinessController.text;
    _business?.nombreDueno = _nameOwnerController.text;
    _business?.direccion = _addressController.text;
    _business?.correo = _emailController.text;
    _business?.telefono = int.parse(_phoneController.text);

    if (_business != null &&
        await BlocProvider.of<BusinessCubit>(context)
            .updateBusiness(_business!)
    ) {
      _showToast(text_update_data, true);
      Navigator.pop(context);
    } else {
      _showToast(text_error_update_data, false);
    }
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
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
