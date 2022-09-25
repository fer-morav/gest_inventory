import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/BusinessCubit.dart';
import 'package:gest_inventory/data/datasource/firebase/StorageDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/UserDataSource.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/IconButton.dart';
import 'package:gest_inventory/ui/components/ProgressDialogComponent.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/custom_toast.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/datasource/firebase/BusinessDataSource.dart';
import '../../utils/enums.dart';
import '../../utils/colors.dart';
import '../components/HeaderPaintComponent.dart';
import '../components/ImageProfileComponent.dart';
import '../components/ImageComponent.dart';
import '../components/ProfilePictureMenu.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({Key? key}) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessState();
}

class _BusinessState extends State<BusinessPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BusinessCubit>(
      create: (_) =>
      BusinessCubit(
        businessRepository: BusinessDataSource(),
        userRepository: UserDataSource(),
        storageRepository: StorageDataSource(),
      )..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<BusinessCubit, BusinessState>(
        listener: (context, state) {
          if (state.message != null) {
            CustomToast.showToast(
              message: state.message!,
              context: context,
              status: state.error,
            );
          }
          if (state.complete) {
            _nextScreenArgs(state.viewer!.id);
          }
        },
        builder: (context, state) {
          final bloc = context.read<BusinessCubit>();

          return WillPopScope(
            onWillPop: () => _willPopCallback(bloc),
            child: Scaffold(
              appBar: AppBarComponent(
                textAppBar: state.actionType == ActionType.add
                    ? title_add_business
                    : state.actionType == ActionType.edit
                        ? title_edit_business
                        : title_info_business,
                onPressed: () => _willPopCallback(bloc),
              ),
              body: state.viewer == null
                  ? ProgressDialogComponent()
                  : ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: CustomPaint(
                            painter: HeaderPaintCurve(),
                            child: state.actionType == ActionType.add ||
                                    state.actionType == ActionType.edit
                                ? ImageProfileComponent(
                                    admin: true,
                                    image: state.profilePhoto,
                                    onPressed: () => _showProfileMenuPhoto(bloc),
                                  )
                                : ImageComponent(
                                    color: adminColor,
                                    size: 120,
                                    photoURL: state.business!.photoUrl,
                                  ),
                          ),
                        ),
                        Visibility(
                          visible: state.actionType == ActionType.open,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                            child: ButtonIcon(
                              onPressed: () => pushNamedWithArgs(context, employees_route, {user_args: state.viewer}),
                              text: title_employees,
                              icon: AppIcons.employees,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextInputForm(
                                labelText: textfield_label_owner,
                                inputType: TextInputType.name,
                                onTap: () {},
                                controller: bloc.ownerController,
                                readOnly: true,
                                inputAction: TextInputAction.next,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_name,
                                labelText: textfield_label_name,
                                inputType: TextInputType.name,
                                onTap: () {},
                                controller: bloc.nameController,
                                inputAction: TextInputAction.next,
                                validator: (name) => bloc.validator(name),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_phone,
                                labelText: textfield_label_number_phone,
                                inputType: TextInputType.phone,
                                onTap: () {},
                                controller: bloc.phoneController,
                                inputAction: TextInputAction.next,
                                validator: (phone) => bloc.phoneValidator(phone),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              DividerComponent(),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  title_address,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              TextInputForm(
                                hintText: textfield_hint_state,
                                labelText: textfield_label_state,
                                inputType: TextInputType.text,
                                state: true,
                                onTap: () {},
                                controller: bloc.stateController,
                                inputAction: TextInputAction.next,
                                validator: (state) => bloc.validator(state),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_city,
                                labelText: textfield_label_city,
                                inputType: TextInputType.text,
                                state: true,
                                onTap: () {},
                                controller: bloc.cityController,
                                inputAction: TextInputAction.next,
                                validator: (city) => bloc.validator(city),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_suburb,
                                labelText: textfield_label_suburb,
                                inputType: TextInputType.text,
                                state: true,
                                onTap: () {},
                                controller: bloc.suburbController,
                                inputAction: TextInputAction.next,
                                validator: (suburb) => bloc.validator(suburb),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_cp,
                                labelText: textfield_label_cp,
                                inputType: TextInputType.number,
                                onTap: () {},
                                controller: bloc.cpController,
                                inputAction: TextInputAction.next,
                                validator: (cp) => bloc.cpValidator(cp),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_address,
                                labelText: textfield_label_address,
                                inputType: TextInputType.streetAddress,
                                onTap: () {},
                                controller: bloc.addressController,
                                inputAction: TextInputAction.next,
                                validator: (address) => bloc.validator(address),
                                readOnly: state.actionType == ActionType.open,
                              ),
                              TextInputForm(
                                hintText: textfield_hint_number,
                                labelText: textfield_label_number,
                                inputType: TextInputType.number,
                                onTap: () {},
                                controller: bloc.numberController,
                                inputAction: TextInputAction.done,
                                validator: (number) => bloc.validator(number),
                                readOnly: state.actionType == ActionType.open,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state.actionType != ActionType.open,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            height: 80,
                            child: ButtonIcon(
                              text: state.actionType == ActionType.add
                                  ? button_register
                                  : button_save,
                              icon: state.actionType == ActionType.add
                                  ? AppIcons.store_add
                                  : AppIcons.save,
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  _registerBusiness(bloc);
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
              floatingActionButton: Visibility(
                visible: state.actionType == ActionType.open && state.viewer!.admin,
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

  Future<bool> _willPopCallback(BusinessCubit bloc) async {
    if (bloc.state.viewer != null) {
      _nextScreenArgs(bloc.state.viewer!.id);
      return true;
    }
    return false;
  }

  void _registerBusiness(BusinessCubit bloc) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => FutureProgressDialog(
        bloc.registerBusiness(),
      ),
    );
  }

  void _showProfileMenuPhoto(BusinessCubit bloc) async {
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

  void _nextScreenArgs(String userId) {
    final args = {
      user_id_args: userId,
    };

    popAndPushNamedWithArgs(context, home_route, args);
  }
}
