import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/firebase/AuthCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/ButtonSecond.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../../domain/bloc/firebase/BusinessCubit.dart';
import '../../domain/bloc/firebase/UserCubit.dart';
import '../../utils/custom_toast.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idBusinessController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final _positionController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  User? admin;
  Business? business;

  bool showPassword = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAdminAndBusiness();
    });
    super.initState();
  }

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: MultiSelect(
                cancelButtonText: button_cancel,
                saveButtonText: button_save,
                clearButtonText: button_reset,
                titleText: title_roles,
                checkBoxColor: Colors.blue,
                selectedOptionsInfoText: "",
                hintText: textfield_label_cargo,
                maxLength: 1,
                maxLengthText: textfield_hint_one_option,
                dataSource: const [
                  {"cargo": title_employees, "code": title_employees},
                  {"cargo": title_administrator, "code": title_administrator},
                ],
                textField: "cargo",
                valueField: "code",
                hintTextColor: primaryColor,
                enabledBorderColor: primaryColor,
                filterable: true,
                required: true,
                onSaved: (value) {
                  _positionController.text = value.toString();
                }),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonSecond(
              onPressed: _registerUser,
              text: button_register_user,
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

  void _getAdminAndBusiness() async {
    String? adminId;
    adminId = BlocProvider.of<AuthCubit>(context).getUserId();
    if (adminId != null) {
      admin = await BlocProvider.of<UserCubit>(context).getUser(adminId);
      if (admin != null) {
        business = await BlocProvider.of<BusinessCubit>(context)
            .getBusiness(admin!.idNegocio);
      }
    }
  }

  void _registerUser() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _salaryController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _positionController.text.isNotEmpty) {

      User user = User(
          id: '',
          idNegocio: '',
          cargo: _positionController.text.trim(),
          nombre: _nameController.text.trim(),
          apellidos: _lastnameController.text.trim(),
          telefono: int.parse(_phoneController.text),
          salario: double.parse(_salaryController.text.trim())
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

    if(result == null || result.isEmpty) {
      _showToast(text_add_user_not_success, false);
      return;
    }

    user.id = result;
    _addUser(user);
  }

  void _addUser(user) async {
    if (admin != null) {
      user.idNegocio = admin!.idNegocio;
      if (await BlocProvider.of<UserCubit>(context).addUser(user)) {
        _showToast(text_add_user_success, true);
        _nextScreen(login_route);
      }
    }
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
