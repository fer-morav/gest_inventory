import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonMain.dart';
import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../data/models/Product.dart';

class OptionsSearchProductsPage extends StatefulWidget {
  const OptionsSearchProductsPage({Key? key}) : super(key: key);

  @override
  State<OptionsSearchProductsPage> createState() => _OptionsSearchProductsPageState();
}

class _OptionsSearchProductsPageState extends State<OptionsSearchProductsPage> {
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
            child: ButtonMain(
              onPressed: () {
                _nextScreenArgs(search_product_code_route, _business!.id.toString());
              },
              text: button_getCode_product,
              isDisabled: true,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {
                scanProductSearch();
              },
              text: button_scanCode_product,
              isDisabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanProductSearch() async {
    TextEditingController idController = TextEditingController();
    scanBarcodeNormal(idController);
  }

  void _nextScreenArgsProduct(String route, Product product) {
    final args = {"args": product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void scanBarcodeNormal( TextEditingController idController) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      idController.text = barcodeScanRes;
    });
    if( (await _businessDataSource.getProduct(_business!.id.toString(), idController.text)) != null ){
      final _product = await _businessDataSource.getProduct(_business!.id.toString(), idController.text);
      _nextScreenArgsProduct(see_product_info_route, _product!);
    }else{
      _showToast("Producto no registrado");
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

  void _nextScreenArgs(String route, String businessId) {
    final args = {"args": businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }
}
