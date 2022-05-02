import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../utils/arguments.dart';

class ViewRecordsPage extends StatefulWidget {
  const ViewRecordsPage({Key? key}) : super(key: key);

  @override
  State<ViewRecordsPage> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecordsPage> {

  late final FirebaseBusinessDataSource _businessDataSource =
  FirebaseBusinessDataSource();
  bool _isLoading = true;

  String? businessId;
  Business? _business;


  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_report,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreenArgs(allincomes_route, _business!.id),
              text: button_compras,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreenArgs(allsales_route, _business!.id),
              text: button_ventas,
              isDisabled: true,
            ),
          ),

        ],
      ),
    );
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    businessId = args[business_id_args];
    _getBusiness(businessId!);
  }

  void _getBusiness(String id) async {
    _businessDataSource.getBusiness(id).then((business) => {
      if (business != null)
        {
          setState(() {
            _business = business;
            _isLoading = false;
          }),
        }
    });
  }
  void _nextScreenArgsBusiness(String route, Business business) {
    final args = {business_args: business};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }
}
