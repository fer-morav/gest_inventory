import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import '../../domain/bloc/AuthCubit.dart';
import '../../utils/colors.dart';
import '../../utils/custom_toast.dart';
import '../../utils/strings.dart';
import 'MainButton.dart';
import 'TextInputForm.dart';

class DialogResetPassword extends StatelessWidget {
  final TextEditingController emailController;

  const DialogResetPassword({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title_reset_password,
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      ),
      content: TextInputForm(
        hintText: textfield_hint_email,
        labelText: textfield_label_email,
        controller: emailController,
        inputType: TextInputType.emailAddress,
        onTap: () {},
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  button_cancel,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 60,
                child: MainButton(
                  onPressed: () => _sendEmailResetPassword(
                      emailController.text.trim(), context),
                  text: button_recover_password,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _sendEmailResetPassword(String email, BuildContext context) async {
    if (email.isNotEmpty) {
      bool result = await showDialog(
        context: context,
        builder: (_) => FutureProgressDialog(
          BlocProvider.of<AuthCubit>(context).sendPasswordResetEmail(email),
        ),
      );

      if (result) {
        CustomToast.showToast(
            message: alert_title_send_email, context: context);
      } else {
        CustomToast.showToast(
          message: alert_title_error_not_registered,
          context: context,
          status: false,
        );
      }
      Navigator.of(context).pop();
    }
  }
}
