import 'package:flutter/material.dart';

import '../utils/colors.dart';

class IndicatorComponent extends StatefulWidget {
  final EdgeInsets margin;
  final Color color;
  final String text;
  final double height;
  final sizeReference = 700.0;

  const IndicatorComponent({
    Key? key,
    required this.margin,
    required this.color,
    required this.text,
    required this.height,
  }) : super(key: key);

  @override
  State<IndicatorComponent> createState() => _IndicatorComponentState();
}

class _IndicatorComponentState extends State<IndicatorComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin,
      alignment: Alignment.center,
      decoration: _boxDecoration(),
      child: FittedBox(
        child: Text(
          widget.text,
          style: _textStyle(),
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: widget.color,
      fontWeight: FontWeight.w800,
      fontSize: getResponsiveText(30),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: primaryOnColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: widget.color,
        width: 4,
      ),
    );
  }

  double getResponsiveText(double size) {
    return size *
        widget.sizeReference /
        MediaQuery.of(context).size.longestSide;
  }
}
