import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class MessageComponent extends StatelessWidget {
  final String text;

  const MessageComponent({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
