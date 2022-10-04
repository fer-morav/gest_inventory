import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/AuthDataSource.dart';
import 'package:gest_inventory/domain/bloc/AuthCubit.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(AuthDataSource())..init(),
      child: MyApp.create(),
    ),
  );
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static Widget create() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state == AuthState.signOut) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(login_route, (route) => false);
        } else if (state == AuthState.signedIn) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(
            home_route,
            (route) => false,
            arguments: {
              user_id_args: context.read<AuthCubit>().getUserId(),
            },
          );
        } else if (state == AuthState.signUp) {
          _navigatorKey.currentState?.pushNamed(register_user_route);
        }
      },
      child: const MyApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: app_name,
      theme: light,
      initialRoute: splash_route,
      routes: getApplicationRoutes(),
    );
  }
}
