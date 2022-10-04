import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';

import '../../utils/resources.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(image_splash_blanco_png, scale: 1.5,),
      ),
    );
  }

  // Future<void> _checkLogin() async {
  //   String? userId = context.read<AuthCubit>().getUserId();
  //
  //   if (userId == null) {
  //     context.read<AuthCubit>().setState(AuthState.signOut);
  //     Navigator.pushNamedAndRemoveUntil(context, login_route, (route) => false);
  //   } else {
  //     User user = await context.read<User>()
  //     final args = {user_args: };
  //     Navigator.pushNamedAndRemoveUntil(context, administrator_route, (route) => false, arguments: {});
  //     context.read<AuthCubit>().setState(AuthState.signedIn);
  //   }
  // }
}
