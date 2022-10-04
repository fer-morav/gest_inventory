import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/icons.dart';

import '../../utils/colors.dart';

class TextInputForm extends StatelessWidget {
  final void Function() onTap;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final bool readOnly;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool passwordTextStatus;
  final String? errorText;
  final TextInputAction? inputAction;
  final bool salary;
  final bool state;
  final bool barcode;

  TextInputForm({
    Key? key,
    required this.onTap,
    this.onChange,
    this.hintText,
    this.labelText,
    this.helperText,
    required this.controller,
    required this.inputType,
    this.errorText,
    this.readOnly = false,
    this.passwordTextStatus = false,
    this.inputAction,
    this.validator,
    this.salary = false,
    this.state = false,
    this.barcode = false,
  }) : super(key: key);

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  );

  final _focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: primaryColor),
  );

  final _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red),
  );

  final _textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: TextFormField(
        keyboardType: inputType,
        controller: controller,
        style: _textStyle,
        onChanged: onChange,
        validator: validator,
        obscureText: passwordTextStatus,
        textInputAction: inputAction,
        readOnly: readOnly,
        decoration: InputDecoration(
          icon: _getIcon(),
          isDense: true,
          errorText: errorText,
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          enabledBorder: _border,
          focusedBorder: _focusBorder,
          errorBorder: _errorBorder,
          border: _border,
          suffixIcon: inputType == TextInputType.visiblePassword
              ? InkWell(
                  onTap: onTap,
                  child: passwordTextStatus
                      ? getIcon(AppIcons.hide)
                      : getIcon(AppIcons.show),
                )
              : barcode
                  ? InkWell(
                      onTap: onTap,
                      child: getIcon(AppIcons.scanner),
                    )
                  : null,
        ),
      ),
    );
  }

  Icon? _getIcon() {
    if (inputType == TextInputType.emailAddress) {
      return getIcon(AppIcons.email);
    } else if (inputType == TextInputType.visiblePassword) {
      return getIcon(AppIcons.password);
    } else if (inputType == TextInputType.phone) {
      return getIcon(AppIcons.phone);
    } else if (inputType == TextInputType.number && salary) {
      return getIcon(AppIcons.salary);
    } else if (inputType == TextInputType.number) {
      return getIcon(AppIcons.quantity);
    } else if (inputType == TextInputType.name) {
      return getIcon(AppIcons.person);
    } else if (inputType == TextInputType.text && state) {
      return getIcon(AppIcons.city);
    } else if (inputType == TextInputType.text && barcode) {
      return getIcon(AppIcons.barcode);
    } else if (inputType == TextInputType.text) {
      return getIcon(AppIcons.text);
    } else if (inputType == TextInputType.streetAddress) {
      return getIcon(AppIcons.address);
    }
    return null;
  }
}
