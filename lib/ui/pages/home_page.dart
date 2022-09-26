import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/UserDataSource.dart';
import 'package:gest_inventory/domain/bloc/AuthCubit.dart';
import 'package:gest_inventory/ui/components/IconButtonComponent.dart';
import 'package:gest_inventory/ui/components/ImageComponent.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/icons.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../domain/bloc/HomeCubit.dart';
import '../../utils/colors.dart';
import '../components/HeaderPaintComponent.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _Home();
}

class _Home extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _textStyle = TextStyle(
    fontSize: 16,
    color: blackColor,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(UserDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.userId == null) {
            _signOut();
          }
          if (state.user == null) {
            final args = {
              action_type_args: ActionType.add,
            };
            pushNamedWithArgs(context, user_route, args);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => exit(0),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: primaryOnColor,
                leading: IconButton(
                  icon: getIcon(AppIcons.menu, color: primaryColor, size: 35),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                title: FittedBox(
                  child: Align(
                    child: Text(
                      app_name,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              drawer: Drawer(
                child: state.user == null
                    ? LoadingComponent()
                    : ListView(
                        children: [
                          Container(
                            height: 30,
                            color: primaryColor,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: CustomPaint(
                              painter: HeaderPaintCurve(),
                              child: ImageComponent(
                                color: state.user!.admin ? adminColor : employeeColor,
                                photoURL: state.user!.photoUrl,
                                size: 105,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              state.user!.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            leading: getIcon(AppIcons.email, color: blackColor),
                            title: Text(
                              state.user!.email,
                              style: _textStyle,
                            ),
                          ),
                          ListTile(
                            leading: getIcon(AppIcons.phone, color: blackColor),
                            title: Text(
                              state.user!.phoneNumber.toString(),
                              style: _textStyle,
                            ),
                          ),
                          ListTile(
                            leading: getIcon(AppIcons.salary, color: blackColor),
                            title: Text(
                              state.user!.salary.toString(),
                              style: _textStyle,
                            ),
                          ),
                          ListTile(
                            trailing: getIcon(AppIcons.edit, color: primaryColor),
                            onTap: () {
                              final args = {
                                action_type_args: ActionType.edit,
                                user_args: state.user,
                              };
                              pushNamedWithArgs(context, user_route, args);
                            },
                            title: Text(
                              button_edit,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ListTile(
                            trailing: getIcon(AppIcons.logout, color: errorColor),
                            onTap: _signOut,
                            title: Text(
                              button_logout,
                              style: TextStyle(
                                color: errorColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              body: state.user == null
                  ? LoadingComponent()
                  : GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      children: [
                        IconButtonComponent(
                          icon: AppIcons.store,
                          text: title_info_business,
                          onPressed: () {
                            final args = {
                              action_type_args: ActionType.open,
                              user_args: state.user,
                            };

                            if (state.user!.idBusiness.isEmpty) {
                              pushNamedWithArgs(context, waiting_route, args);
                            } else {
                              pushNamedWithArgs(context, business_route, args);
                            }
                          },
                        ),
                        IconButtonComponent(
                          icon: AppIcons.products,
                          text: title_list_product,
                          onPressed: () => pushNamedWithArgs(context, list_products_route, {user_args: state.user}),
                        ),
                        IconButtonComponent(
                          icon: AppIcons.shopping,
                          text: title_make_sale,
                          onPressed: () => pushNamedWithArgs(context, make_sale_route, {user_args: state.user}),
                        ),
                        IconButtonComponent(
                          icon: AppIcons.statics,
                          text: title_statistics,
                          onPressed: () => pushNamedWithArgs(context, statistics_route, {user_args: state.user}),
                        ),
                        Visibility(
                        visible: state.user!.admin,
                        child: IconButtonComponent(
                          icon: AppIcons.edit_product,
                          text: title_restock_product,
                          onPressed: () {},
                        ),
                      ),
                      Visibility(
                        visible: state.user!.admin,
                        child: IconButtonComponent(
                          icon: AppIcons.inform,
                          text: title_inform,
                          onPressed: () => {},
                        ),
                      ),
                    ],
                  ),
            ),
          );
        }
      ),
    );
  }

  void _signOut() async {
    context.read<AuthCubit>().signOut();
  }
}