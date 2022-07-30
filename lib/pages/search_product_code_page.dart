import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/components/TextInputForm.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonSecond.dart';
import '../data/firebase/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../data/models/Product.dart';
import '../utils/scan_util.dart';

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

  ScanUtil _scanUtil = ScanUtil();

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
                  child: TextInputForm(
                    hintText: textfield_hint_product,
                    labelText: textfield_label_product,
                    controller: idProductController,
                    inputType: TextInputType.text,
                    onTap: () {},
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed: () {
                      _searchProduct();
                    },
                    text: button_search_product,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.qr_code_scanner,
          color: primaryColor,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          _scanProductSearch();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _scanProductSearch() async {
    idProductController.text = await _scanUtil.scanBarcodeNormal();
    if ((await _businessDataSource.getProduct(
            _business!.id.toString(), idProductController.text)) !=
        null) {
      final _product = await _businessDataSource.getProduct(
          _business!.id.toString(), idProductController.text);
      _nextScreenArgsProduct(see_product_info_route, _product!);
    } else {
      _showToast("Producto no registrado");
    }
  }

  void _nextScreenArgsProduct(String route, Product product) {
    final args = {product_args: product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Future<void> _searchProduct() async {
    String idproduct = idProductController.text.split(" ").first;

    if (idproduct.isEmpty) {
      _showToast(alert_content_imcomplete);
    } else {
      if ((await _businessDataSource.getProduct(
              _business!.id.toString(), idproduct)) !=
          null) {
        final _product = await _businessDataSource.getProduct(
            _business!.id.toString(), idproduct);
        _nextScreenArgsProduct(see_product_info_route, _product!);
      } else {
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
}
