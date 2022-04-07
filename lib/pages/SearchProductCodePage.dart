import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../data/models/Product.dart';

class SearchProductCodePage extends StatefulWidget {
  const SearchProductCodePage({Key? key}) : super(key: key);

  @override
  State<SearchProductCodePage> createState() => _SearchProductCodePageState();
}

class _SearchProductCodePageState extends State<SearchProductCodePage> {

  TextEditingController idProductController = TextEditingController();

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
        textAppBar: title_opSearch_product,
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
            child: TextFieldMain(
              hintText: textfield_hint_product,
              labelText: textfield_label_product,
              textEditingController: idProductController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {
                _searchProduct();
              },
              text: button_search_product,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchProduct() async {
    String idproduct = idProductController.text.split(" ").first;

    if (idproduct.isEmpty ) {
      _showToast(alert_content_imcomplete);
    } else {
      if( (await _businessDataSource.getProduct(_business!.id.toString(), idproduct )) != null ){
        final _product = await _businessDataSource.getProduct(_business!.id.toString(), idproduct );
        _nextScreenArgs(see_product_info_route, _product!);
      }else{
       _showToast("Código invalido");
      }
    }
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    businessId = args["args"];
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

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  /*void _nextScreenArgs(String route, String businessId) {
    final args = {"args": businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }*/
  void _nextScreenArgs(String route, Product product) {
    final args = {"args": product};
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
