import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/ui/components/TextInputForm.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import '../../utils/arguments.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/strings.dart';
import 'MainButton.dart';

class UpdateUserDialogComponent extends StatefulWidget {
  final User user;

  const UpdateUserDialogComponent({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UpdateUserDialogComponent> createState() =>
      _UpdateUserDialogComponentState();
}

class _UpdateUserDialogComponentState extends State<UpdateUserDialogComponent> {
  final salaryController = TextEditingController();
  bool admin = false;

  @override
  void initState() {
    salaryController.text = widget.user.salary.toString();
    admin = widget.user.admin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title_update_data,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: FittedBox(
              child: Text(
                title_administrator,
                style: TextStyle(fontSize: 20),
              ),
            ),
            leading: getIcon(
              AppIcons.admin,
              color: admin ? primaryColor : null,
            ),
            trailing: Switch(
              value: admin,
              activeColor: primaryColor,
              onChanged: (bool value) => setState(() => this.admin = value),
            ),
          ),
          TextInputForm(
            hintText: textfield_hint_salary,
            labelText: textfield_label_salary,
            onTap: () {},
            controller: salaryController,
            inputType: TextInputType.number,
            salary: true,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => popWithResult(context, {result_args: button_cancel}),
                child: Text(
                  button_cancel,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 60,
                child: MainButton(
                  onPressed: () {
                    popWithResult(
                      context,
                      {
                        result_args: button_save,
                        admin_args: this.admin,
                        salary_args: double.parse(salaryController.text.trim()),
                      },
                    );
                  },
                  text: button_save,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
