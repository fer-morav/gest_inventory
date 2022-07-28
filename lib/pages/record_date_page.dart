import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../data/firebase/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../utils/arguments.dart';


class RecordDatePage extends StatefulWidget {
  const RecordDatePage({Key? key}) : super(key: key);

  @override
  State<RecordDatePage> createState() => _RecordDateState();
}

class _RecordDateState extends State<RecordDatePage> {

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
              onPressed: () => _nextScreenArgs(allsales_route, _business!.id),
              text: button_hoy,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreenArgs(allsales_route, _business!.id),
              text: button_semana,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () => _nextScreenArgs(allsales_route, _business!.id),
              text: button_mes,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
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

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
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
