import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
