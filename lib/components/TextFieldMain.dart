import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextFieldMain extends StatefulWidget {
  final Function() onTap;
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final bool isPassword;
  final bool isPasswordTextStatus;
  final String? errorText;
  final bool? isNumber;

  const TextFieldMain(
      {Key? key,
      required this.hintText,
      required this.labelText,
      required this.textEditingController,
      required this.isPassword,
      required this.isPasswordTextStatus,
      this.errorText,
      required this.onTap, this.isNumber})
      : super(key: key);

  @override
  State<TextFieldMain> createState() => _TextFieldMainState();
}

class _TextFieldMainState extends State<TextFieldMain> {
  final _border = const UnderlineInputBorder(
    //borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: primaryColor),
  );

  final _errorBorder = const UnderlineInputBorder(
    //borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.isNumber != null ? TextInputType.number : TextInputType.text,
      controller: widget.textEditingController,
      autofocus: false,
      autocorrect: true,
      textAlign: TextAlign.left,
      obscureText: widget.isPasswordTextStatus,
      style: const TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        errorText: widget.errorText,
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: _border,
        focusedBorder: _border,
        errorBorder: _errorBorder,
        border: _border,
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: widget.isPassword ? widget.onTap : null,
                child: (widget.isPassword
                    ? (widget.isPasswordTextStatus
                        ? const Icon(Icons.visibility_off, color: primaryColor)
                        : const Icon(Icons.visibility, color: primaryColor))
                    : null),
              )
            : null,
      ),
    );
  }
}
