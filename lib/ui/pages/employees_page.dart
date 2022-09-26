import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gest_inventory/data/datasource/firebase/UserDataSource.dart';
import 'package:gest_inventory/domain/bloc/EmployeesCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/ui/components/SelectUserComponent.dart';
import 'package:gest_inventory/ui/components/SpeedDialComponent.dart';
import 'package:gest_inventory/ui/components/UpdateUserDialogComponent.dart';
import 'package:gest_inventory/ui/components/UserComponent.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/User.dart';
import '../../utils/enums.dart';
import '../../utils/arguments.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/routes.dart';
import '../components/MessageComponent.dart';
import '../components/search_user_delegate.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeesCubit>(
      create: (_) => EmployeesCubit(userRepository: UserDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocBuilder<EmployeesCubit, EmployeesState>(
        builder: (context, state) {
          final employeesBloc = context.read<EmployeesCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_employees,
              onPressed: () => pop(context),
              action: IconButton(
                icon: getIcon(AppIcons.search, size: 30),
                onPressed: () => _searchUser(employeesBloc),
              ),
            ),
            body: state.user == null
                ? LoadingComponent()
                : StreamBuilder<List<User>>(
                    stream: employeesBloc.listStreamUsers(state.user!.idBusiness),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return MessageComponent(text: text_connection_error);
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return MessageComponent(text: text_empty_list);
                      }
                      if (snapshot.hasData) {
                        return _component(snapshot.data!, employeesBloc);
                      }

                      return LoadingComponent();
                    },
                  ),
            floatingActionButton: state.user != null && state.user!.admin
                ? SpeedDialComponent(
                    actionType: state.actionType,
                    onPressed: state.actionType != ActionType.select
                        ? () => employeesBloc.setAction(ActionType.select)
                        : null,
                    children: [
                      SpeedDialChild(
                        onTap: () => employeesBloc.setAction(ActionType.delete),
                        backgroundColor: primaryOnColor,
                        child: getIcon(AppIcons.delete, color: errorColor, size: 30),
                      ),
                      SpeedDialChild(
                        onTap: () => employeesBloc.setAction(ActionType.edit),
                        backgroundColor: primaryOnColor,
                        child: getIcon(AppIcons.edit, color: primaryColor, size: 30),
                      ),
                      SpeedDialChild(
                        onTap: () => _addEmployee(employeesBloc),
                        backgroundColor: primaryOnColor,
                        child: getIcon(AppIcons.add, color: primaryColor, size: 30),
                      ),
                    ],
                  )
                : Container(),
          );
        },
      ),
    );
  }

  void _searchUser(EmployeesCubit bloc) async {
    if (bloc.state.user == null) {
      return;
    }

    User? user = await showSearch<User?>(
      context: context,
      delegate: SearchUserDelegate(
        users: await bloc.listUsers(bloc.state.user!.idBusiness),
        actionType: bloc.state.actionType,
      ),
    );

    if (user == null) {
      return;
    }

    switch(bloc.state.actionType) {
      case ActionType.edit:
        _updateValues(user, bloc);
        break;
      case ActionType.select:
        _nextScreen(user);
        break;
      case ActionType.delete:
        _deleteEmployee(user, bloc);
        break;
      default:
        break;
    }
  }

  Widget _component(List<User> users, EmployeesCubit bloc) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: UserComponent(
            user: users[index],
            onTap: () => bloc.state.actionType == ActionType.edit
                ? _updateValues(users[index], bloc)
                : bloc.state.actionType == ActionType.delete
                    ? _deleteEmployee(users[index], bloc)
                    : _nextScreen(users[index]),
            actionType: bloc.state.actionType,
          ),
        );
      },
    );
  }

  void _nextScreen(User user) {
    final args = {
      action_type_args: ActionType.open,
      user_args: user,
    };
    pushNamedWithArgs(context, user_route, args);
  }

  void _updateValues(User user, EmployeesCubit bloc) async {
    Map<String, dynamic> result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return UpdateUserDialogComponent(user: user);
      },
    );

    if (result[result_args] == button_save) {
      bloc.updateValues(user.id, result[admin_args], result[salary_args]);
    }
  }

  void _addEmployee(EmployeesCubit bloc) async {
    User? user = await showDialog(
      context: context,
      builder: (_) {
        return SelectUserComponent(
          listUser: bloc.availableUsers(),
          indications: text_indications_add_user,
        );
      },
    );

    if (user != null) {
      Map<String, dynamic> result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UpdateUserDialogComponent(user: user);
        },
      );

      if (result[result_args] == button_save) {
        bloc.addEmployee(
          user.id,
          bloc.state.user!.idBusiness,
          result[admin_args],
          result[salary_args],
        );
      }
    }
  }

  Future<void> _deleteEmployee(User user, EmployeesCubit bloc) async {
    final result = await showOkCancelAlertDialog(
      title: title_confirm_delete,
      message: '$text_want_remove ${user.name} $text_as_employee',
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
      bloc.deleteEmployee(user.id);
    }
  }
}