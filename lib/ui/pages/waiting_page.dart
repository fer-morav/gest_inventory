import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/bloc/WaitingCubit.dart';
import 'package:gest_inventory/data/datasource/firebase/UserDataSource.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import '../../data/models/User.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../../utils/routes.dart';
import '../../utils/strings.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitingCubit>(
      create: (_) => WaitingCubit(UserDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<WaitingCubit, WaitingState>(
        listener: (context, state) {
          if (state.businessId != null && state.businessId!.isNotEmpty) {
            context.read<WaitingCubit>().updateStatus(false);

            final args = {
              user_id_args: state.user?.id,
            };

            popAndPushNamedWithArgs(context, home_route, args);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => _willPopCallback(context),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: primaryLight,
                leading: IconButton(
                  icon: getIcon(
                    AppIcons.arrow_back,
                    color: primaryOnColor,
                    size: 35,
                  ),
                  onPressed: () => _willPopCallback(context),
                ),
              ),
              backgroundColor: primaryLight,
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                      bottom: 100,
                    ),
                    child: Transform.scale(
                      scale: 6,
                      child: getIcon(
                        AppIcons.store_slash,
                        color: primaryOnColor,
                      ),
                    ),
                  ),
                  Text(
                    title_arent_signed_up_business,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryOnColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: text_waiting_help,
                        style: TextStyle(
                          fontSize: 15,
                          color: primaryOnColor,
                        ),
                        children: [
                          TextSpan(
                            text: text_waiting_message,
                            style: TextStyle(
                              color: primaryOnColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    text_or,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryOnColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextButton(
                      onPressed: state.user == null
                          ? () {}
                          : () => _registerBusiness(context, state.user),
                      child: Text(
                        button_register_business,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: primaryOnColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    final bloc = context.read<WaitingCubit>();

    await bloc.updateStatus(false);
    bloc.reset();

    return false;
  }

  void _registerBusiness(BuildContext context, User? user) async {
    final bloc = context.read<WaitingCubit>();

    await bloc.updateStatus(false);

    final args = {
      action_type_args: ActionType.add,
      user_args: user,
    };

    popAndPushNamedWithArgs(context, business_route, args);
  }
}
