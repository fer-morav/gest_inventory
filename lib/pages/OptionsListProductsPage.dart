import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';

class OptionsListProductsPage extends StatefulWidget {
  const OptionsListProductsPage({Key? key}) : super(key: key);

  @override
  State<OptionsListProductsPage> createState() => _OptionsListProductsPageState();
}

class _OptionsListProductsPageState extends State<OptionsListProductsPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
  FirebaseBusinessDataSource();

  String? businessId;
  Business? _business;
  bool _isLoading = true;

  @override
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
        textAppBar: title_opList_product,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonMain(
                    onPressed: () {
                      _nextScreenArgs(allList_product_page, _business!.id.toString());
                    },
                    text: button_allList_product,
                    isDisabled: true,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonMain(
                    onPressed: () {
                      //_nextScreenArgs(search_product_route, _business!.id.toString());
                      _nextScreenArgsSearch(search_product_route, _business!);
                    },
                    text: button_nameList_product,
                    isDisabled: true,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonMain(
                    onPressed: () {
                      //_nextScreenArgs(info_business_route, user!.idNegocio.toString());
                    },
                    text: button_codeList_product,
                    isDisabled: true,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Icon(Icons.edit),
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

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _nextScreenArgsSearch(String route, Business business) {
    final args = {business_args: business};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Text _labelText(String text, bool right) {
    return Text(
      text,
      textAlign: right ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: right ? Colors.black87 : primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}
