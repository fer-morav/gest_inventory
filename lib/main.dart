import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseAuthDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseIncomingDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseSalesDataSource.dart';
import 'package:gest_inventory/domain/bloc/firebase/AuthCubit.dart';
import 'package:gest_inventory/domain/bloc/firebase/UserCubit.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/utils/themes.dart';
import 'data/datasource/firebase/FirebaseUserDataSource.dart';
import 'domain/bloc/firebase/BusinessCubit.dart';
import 'domain/bloc/firebase/IncomingCubit.dart';
import 'domain/bloc/firebase/ProductCubit.dart';
import 'domain/bloc/firebase/SalesCubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(FirebaseAuthDataSource())..init(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(FirebaseUserDataSource()),
        ),
        BlocProvider<BusinessCubit>(
          create: (_) => BusinessCubit(FirebaseBusinessDataSource()),
        ),
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit(FirebaseProductDataSource()),
        ),
        BlocProvider<SalesCubit>(
          create: (_) => SalesCubit(FirebaseSalesDataSource()),
        ),
        BlocProvider<IncomingCubit>(
          create: (_) => IncomingCubit(FirebaseIncomingDataSource()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_name,
      theme: light,
      initialRoute: login_route,
      routes: getApplicationRoutes(),
    );
  }
}
