import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/scan_util.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:gest_inventory/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';

class MakeSalePage extends StatefulWidget {
  const MakeSalePage({Key? key}) : super(key: key);

  @override
  State<MakeSalePage> createState() => _MakeSalePageState();
}

class _MakeSalePageState extends State<MakeSalePage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  String? businessId;
  ScanUtil _scanUtil = ScanUtil();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  List<String> litems = [];
  late List<Product> listProduct=[];
  final TextEditingController eCtrl = new TextEditingController();
  final sizeReference = 700.0;
  String? _nombreError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_make_sale,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {
                //_payProduct();
              },
              text: button_paying_products,
              isDisabled: false,
            ),
          ),
          Container(
            height: 35,
            margin: const EdgeInsets.only(
              left: 80,
              top: 10,
              right: 80,
              bottom: 10,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                    color: litems.length > 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: FittedBox(
              child: Text(
                litems.length > 0 ? text_in_cart : text_empty_cart,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: litems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int Index) {
                final item = litems[Index];
                return Dismissible(
                  onDismissed: (_) {
                    litems.removeAt(Index);
                    listProduct.removeAt(Index);
                    _showToast(text_removed_product);
                    setState(() {});
                  },
                  movementDuration: Duration(milliseconds: 100),
                  key: Key(item),
                  child: ListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Transform.scale(
                            scale: 1.6,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color:
                                listProduct[Index].stock.toString() == "0.0" ? Colors.redAccent : Colors.greenAccent,
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            listProduct[Index].nombre,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "\$ "+listProduct[Index].precioUnitario.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Stock: "+listProduct[Index].stock.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    color: primaryColor,
                  ),
                );
              }
            ),
          ),
          
        ],
      ),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.qr_code_scanner,
              color: primaryColor,
            ),
            backgroundColor: Colors.white,
            
            onPressed: () {
              scanBarcodeNormal();
            },
          ),
          SizedBox(height: 5),
          FloatingActionButton(
            child: Icon(
              Icons.abc_sharp,
              color: primaryColor,
              size: 35,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              DialogSearchByName(); 
            },
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
    setState(() {});
  }

  void _addProduct() async {
    litems.add(idController.text);
    idController.clear();
    setState(() {});
    _showToast(text_added_product);
  }

  void scanQR() async {
    if (!mounted) return;

    idController.text = await _scanUtil.scanQR();
  }

  void scanBarcodeNormal() async {
    idController.text = await _scanUtil.scanBarcodeNormal();
    if( (await _businessDataSource.getProduct(businessId!, idController.text)) != null ){
      final _product = await _businessDataSource.getProduct(businessId!, idController.text);
      if(_product!.stock != 0.0){
        listProduct.add(_product);
        _addProduct();
      }else{
        _showToast(text_product_not_avilable); 
      }
    }else{
      _showToast(text_unregistered_product);
    }
    if (!mounted) return;
  }

  void DialogSearchByName(){
    showDialog(
      context: context,
      builder: (buildContext){
        return AlertDialog(
          title: Text(text_search_by_name),
          content: Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_name_product,
              labelText: textfield_label_name_product,
              textEditingController: nameController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _nombreError,
            ),
          ),
          actions: <Widget>[
            ButtonMain(
              onPressed: () {
                Navigator.of(context).pop();
                searchByName();
              },
              text: button_search,
              isDisabled: false,
            ),
          ],
        );
      }
    );
  }

  void searchByName(){
    _businessDataSource
        .getProductForName(businessId!, nameController.text)
        .then((product) => {
              if (product != null)
                {
                  if(product.stock != 0.0){
                    listProduct.add(product),
                    _addProduct(),
                  }else{
                    _showToast(text_product_not_avilable),
                  }
                }
              else
                {
                  _showToast(text_product_not_found),
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
    final args = {business_id_args: businessId};
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

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;
  
}
