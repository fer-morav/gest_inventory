import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/ButtonMain.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../../domain/bloc/firebase/AuthCubit.dart';
import '../../domain/bloc/firebase/UserCubit.dart';
import '../../utils/custom_toast.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_register_user,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
            width: double.infinity,
          ),
          TextInputForm(
            hintText: textfield_hint_email,
            labelText: textfield_label_email,
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_password,
            labelText: textfield_label_password,
            controller: _passwordController,
            inputType: TextInputType.visiblePassword,
            passwordTextStatus: showPassword,
            onTap: _showPassword,
          ),
          TextInputForm(
            hintText: textfield_hint_name,
            labelText: textfield_label_name,
            controller: _nameController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_last_name,
            labelText: textfield_label_last_name,
            controller: _lastnameController,
            inputType: TextInputType.name,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_phone,
            labelText: textfield_label_number_phone,
            controller: _phoneController,
            inputType: TextInputType.phone,
            onTap: () {},
          ),
          TextInputForm(
            hintText: textfield_hint_salary,
            labelText: textfield_label_salary,
            controller: _salaryController,
            inputType: TextInputType.number,
            onTap: () {},
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: _registerUser,
              text: button_register_user,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _registerUser() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _salaryController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty
    ) {
      User user = User(
        id: '',
        idNegocio: '',
        cargo: "[Administrador]",
        nombre: _nameController.text.trim(),
        apellidos: _lastnameController.text.trim(),
        telefono: int.parse(_phoneController.text.trim()),
        salario: double.parse(_salaryController.text.trim()),
      );

      _signUp(_emailController.text.trim(), _passwordController.text.trim(), user);
    } else {
      _showToast(alert_content_incomplete, false);
    }
  }

  void _signUp(String email, String password, User user) async {
    String? result = await showDialog(
      context: context,
      builder: (_) => FutureProgressDialog(
        BlocProvider.of<AuthCubit>(context).signUpWithEmail(email, password),
      ),
    );

    if (result == null || result.isEmpty) {
      _showToast(text_add_user_not_success, false);
      return;
    }

    user.id = result;

    await BlocProvider.of<UserCubit>(context).addUser(user);
    _nextScreen(add_business_route);
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }
}
