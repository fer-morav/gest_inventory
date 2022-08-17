import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/firebase/AuthCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/ButtonMain.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/custom_toast.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/datasource/firebase/FirebaseBusinessDataSource.dart';
import '../../data/models/Business.dart';
import '../../data/models/User.dart';
import '../../domain/bloc/firebase/UserCubit.dart';

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

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  final _businessController = TextEditingController();
  final _ownerController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _businessController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
          TextInputForm(
            hintText: textfield_hint_name,
            labelText: textfield_label_name,
            controller: _businessController,
            inputType: TextInputType.name,
            passwordTextStatus: false,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_email,
            labelText: textfield_label_email,
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_name_owner,
            labelText: textfield_label_owner,
            controller: _ownerController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_address,
            labelText: textfield_label_address,
            controller: _addressController,
            inputType: TextInputType.streetAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_phone,
            labelText: textfield_label_number_phone,
            controller: _phoneController,
            inputType: TextInputType.phone,
            onTap: () {},
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

  void _addBusiness(Business business) async {
    if (business.idDueno.isNotEmpty) {
      User? user = await showDialog(
        context: context,
        builder: (_) => FutureProgressDialog(
          BlocProvider.of<UserCubit>(context).getUser(business.idDueno),
        ),
      );

      if (user == null) {
        _showToast(
            alert_title_error_general + ' ' + alert_content_error_general,
            context,
            false);
        return;
      }

      String? businessId = await showDialog(
        context: context,
        builder: (_) => FutureProgressDialog(
          _businessDataSource.addBusiness(business),
        ),
      );

      if (businessId == null || businessId.isEmpty) {
        _showToast(
            alert_title_error_general + ' ' + alert_content_error_general,
            context,
            false);
        return;
      }

      _showToast(text_add_business_success, context, true);

      user.idNegocio = businessId;

      await showDialog(
        context: context,
        builder: (_) => FutureProgressDialog(
          BlocProvider.of<UserCubit>(context).updateUser(user),
        ),
      );

      _nextScreenArgs(administrator_route, user);
    }
  }

  void _nextScreenArgs(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _saveDataBusiness() {
    if (_businessController.text.isNotEmpty &&
        _ownerController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      final business = Business(
        id: '',
        nombreNegocio: _businessController.text.trim(),
        nombreDueno: _ownerController.text.trim(),
        idDueno: BlocProvider.of<AuthCubit>(context).getUserId() ?? '',
        direccion: _addressController.text.trim(),
        correo: _emailController.text.trim(),
        telefono: int.parse(_phoneController.text.trim()),
        activo: true,
      );

      _addBusiness(business);
    } else {
      _showToast(alert_content_incomplete, context, false);
    }
  }

  void _showToast(String message, BuildContext? context, bool status) {
    CustomToast.showToast(message: message, context: context, status: status);
  }
}
