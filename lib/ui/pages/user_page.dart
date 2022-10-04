import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/UserCubit.dart';
import 'package:gest_inventory/data/datasource/firebase/StorageDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/UserDataSource.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/HeaderPaintComponent.dart';
import 'package:gest_inventory/ui/components/IconButton.dart';
import 'package:gest_inventory/ui/components/ImageProfileComponent.dart';
import 'package:gest_inventory/ui/components/ImageComponent.dart';
import 'package:gest_inventory/ui/components/ProfilePictureMenu.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../../domain/bloc/AuthCubit.dart';
import '../../utils/arguments.dart';
import '../../utils/custom_toast.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (_) => UserCubit(
          userRepository: UserDataSource(),
          storageRepository: StorageDataSource())
        ..init(
          context.read<AuthCubit>(),
          ModalRoute.of(context)?.settings.arguments as Map,
        ),
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) async {
          if (state.message != null) {
            CustomToast.showToast(
              message: state.message!,
              context: context,
              status: state.error,
            );
          }
          if (state.message == text_add_user_success && state.isAdmin) {
            _registerBusiness(state.user!);
            return;
          }
          if (state.message == text_update_data || state.message == text_add_user_success) {
            final args = {
              user_id_args: state.viewerId,
            };

            popAndPushNamedWithArgs(context, home_route, args);
          }
        },
        builder: (context, state) {
          final bloc = context.read<UserCubit>();

          return WillPopScope(
            onWillPop: () => _willPopCallback(context),
            child: Scaffold(
              appBar: AppBarComponent(
                textAppBar: state.actionType == ActionType.add
                    ? title_register_user
                    : state.actionType == ActionType.edit
                        ? title_edit_user
                        : title_user,
                onPressed: () => _willPopCallback(context),
              ),
              body: state.viewerId == null && state.email == null
                  ? LoadingComponent()
                  : ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: CustomPaint(
                            painter: HeaderPaintCurve(),
                            child: state.actionType == ActionType.add ||
                                    state.actionType == ActionType.edit
                                ? ImageProfileComponent(
                                    admin: state.isAdmin,
                                    image: state.profilePhoto,
                                    onPressed: () => _showProfileMenuPhoto(bloc),
                                  )
                                : ImageComponent(
                                    color: state.isAdmin ? adminColor : employeeColor,
                                    size: 120,
                                    photoURL: state.user!.photoUrl,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        ListTile(
                          title: Text(title_administrator),
                          subtitle: state.actionType == ActionType.edit
                              ? Text('$textfield_helper_position $textfield_helper_required_admin')
                              : Container(),
                          leading: getIcon(
                            AppIcons.admin,
                            color: state.isAdmin ? primaryColor : null,
                          ),
                          trailing: Switch(
                            value: state.isAdmin,
                            activeColor: primaryColor,
                            onChanged: (bool value) {
                              if (state.actionType == ActionType.add || state.user!.admin) {
                                bloc.setIsAdmin(value);
                              }
                            },
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextInputForm(
                                hintText: textfield_hint_name,
                                labelText: textfield_label_name,
                                controller: bloc.nameController,
                                inputType: TextInputType.name,
                                onTap: () {},
                                readOnly: state.actionType == ActionType.open,
                                inputAction: TextInputAction.next,
                                validator: (name) => bloc.nameValidator(name),
                              ),
                              TextInputForm(
                                hintText: textfield_hint_phone,
                                labelText: textfield_label_number_phone,
                                controller: bloc.phoneController,
                                inputType: TextInputType.phone,
                                onTap: () {},
                                inputAction: TextInputAction.next,
                                readOnly: state.actionType == ActionType.open,
                                validator: (phone) => bloc.phoneValidator(phone),
                              ),
                              DividerComponent(),
                              TextInputForm(
                                hintText: textfield_hint_salary,
                                labelText: textfield_label_salary,
                                controller: bloc.salaryController,
                                inputType: TextInputType.number,
                                salary: true,
                                onTap: () {},
                                inputAction: TextInputAction.next,
                                readOnly: state.actionType != ActionType.add && !state.user!.admin,
                                validator: (salary) => bloc.salaryValidator(salary),
                                helperText: state.actionType == ActionType.edit
                                    ? '$textfield_helper_salary $textfield_helper_required_admin'
                                    : null,
                              ),
                              DividerComponent(),
                              TextInputForm(
                                hintText: textfield_hint_email,
                                labelText: textfield_label_email,
                                controller: bloc.emailController,
                                inputType: TextInputType.emailAddress,
                                onTap: () {},
                                inputAction: TextInputAction.next,
                                readOnly: true,
                                validator: (email) => bloc.emailValidator(email),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Visibility(
                          visible: state.actionType != ActionType.open,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 80,
                            child: ButtonIcon(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  _registerUser(bloc);
                                }
                              },
                              text: state.actionType == ActionType.edit
                                  ? button_save
                                  : button_register,
                              icon: state.actionType == ActionType.edit
                                  ? AppIcons.save
                                  : AppIcons.signup,
                            ),
                          ),
                        ),
                      ],
                    ),
              floatingActionButton: Visibility(
                visible: state.actionType == ActionType.open && state.user!.id == state.viewerId,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () => bloc.setActionType(ActionType.edit),
                  child: getIcon(
                    AppIcons.edit,
                    color: primaryOnColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    final bloc = context.read<UserCubit>();

    if (bloc.state.user == null) {
      context.read<AuthCubit>().signOut();
    } else {
      Navigator.pop(context);
    }
    return true;
  }

  void _showProfileMenuPhoto(UserCubit bloc) async {
    String? result = await showDialog(
      context: context,
      builder: (_) {
        return ProfilePictureMenu();
      },
    );

    if (result == null || result.isEmpty) {
      return;
    }

    bloc.setProfilePhoto(result);
  }

  void _registerUser(UserCubit bloc) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => FutureProgressDialog(
        bloc.registerUser(),
      ),
    );
  }

  void _registerBusiness(User user) async {
    final result = await showOkCancelAlertDialog(
      title: text_signup_business,
      context: context,
      okLabel: button_yes,
      cancelLabel: button_no,
      barrierDismissible: false,
      isDestructiveAction: false,
      onWillPop: () async {
        return false;
      },
    );

    if (result == OkCancelResult.ok) {
      final args = {
        action_type_args: ActionType.add,
        user_args: user,
      };

      popAndPushNamedWithArgs(context, business_route, args);
      return;
    }

    final args = {
      user_id_args: user.id,
    };

    popAndPushNamedWithArgs(context, home_route, args);
  }
}
