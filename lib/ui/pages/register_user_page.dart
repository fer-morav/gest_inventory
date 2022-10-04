import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/bloc/RegisterUserCubit.dart';
import 'package:gest_inventory/domain/bloc/AuthCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import '../../utils/colors.dart';
import '../../utils/custom_toast.dart';
import '../../utils/icons.dart';
import '../../utils/resources.dart';
import '../../utils/strings.dart';
import '../components/HeaderPaintComponent.dart';
import '../components/IconButton.dart';
import '../components/TextInputForm.dart';

class RegisterUserPage extends StatelessWidget {
  RegisterUserPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterUserCubit>(
      create: (_) => RegisterUserCubit(),
      child: BlocBuilder<RegisterUserCubit, RegisterUserState>(
        builder: (context, state) {
          final bloc = context.read<RegisterUserCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_register_user,
              onPressed: () => context.read<AuthCubit>().setState(AuthState.signOut),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: HeaderPaintDiagonal(),
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: Image.asset(image_logo_blanco_png),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: primaryOnColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                TextInputForm(
                                  hintText: textfield_hint_email,
                                  labelText: textfield_label_email,
                                  controller: bloc.emailController,
                                  inputType: TextInputType.emailAddress,
                                  onTap: () {},
                                  validator: (email) => bloc.emailValidator(email),
                                  inputAction: TextInputAction.next,
                                  readOnly: state.loading,
                                ),
                                TextInputForm(
                                  hintText: textfield_hint_password,
                                  labelText: textfield_label_password,
                                  helperText: textfield_helper_password,
                                  controller: bloc.passwordController,
                                  inputType: TextInputType.visiblePassword,
                                  passwordTextStatus: state.showPassword,
                                  onTap: () => bloc.showPassword(),
                                  validator: (password) => bloc.passwordValidator(password),
                                  inputAction: TextInputAction.next,
                                  readOnly: state.loading,
                                ),
                                TextInputForm(
                                  hintText: textfield_hint_password,
                                  labelText: textfield_label_confirm_password,
                                  controller: bloc.confirmPasswordController,
                                  inputType: TextInputType.visiblePassword,
                                  passwordTextStatus: state.showConfirmPassword,
                                  onTap: () => bloc.showConfirmPassword(),
                                  inputAction: TextInputAction.done,
                                  validator: (confirm) => bloc.confirmValidator(confirm, bloc.passwordController.text.trim()),
                                  readOnly: state.loading,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          state.loading
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: ButtonIcon(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() == true) {
                                        bloc.setLoading(true);

                                        _signUp(
                                          bloc.emailController.text.trim(),
                                          bloc.passwordController.text.trim(),
                                          context,
                                          context.read<AuthCubit>(),
                                        );
                                      }
                                    },
                                    text: button_register,
                                    icon: AppIcons.signup,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _signUp(String email, String password, BuildContext context, AuthCubit auth) async {
    String? userId = await auth.signUpWithEmail(email, password);

    if (userId == null || userId.isEmpty) {
      context.read<RegisterUserCubit>().setLoading(false);
      CustomToast.showToast(
        message: '$alert_title_error_general, $alert_content_error_general',
        context: context,
        status: false,
      );
    }
  }
}
