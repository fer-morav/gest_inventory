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

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioUnitarioController = TextEditingController();
  TextEditingController precioMayoreoController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  String? _idError;
  String? _nombreError;
  String? _precioUnitarioError;
  String? _precioMayoreoError;
  String? _stockError;

  Product _product = Product(
    id: "",
    idNegocio: "",
    nombre: "",
    precioUnitario: 0.0,
    precioMayoreo: 0.0,
    stock: 0.0,
    ventaSemana: 0,
    ventaMes: 0,
  );

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
    nombreController.dispose();
    precioUnitarioController.dispose();
    precioMayoreoController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_add_product,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_id,
              labelText: textfield_label_id,
              textEditingController: idController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _idError,
            ),
          ),
          Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_name,
              labelText: textfield_label_name,
              textEditingController: nombreController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _nombreError,
            ),
          ),
          Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_unit_price,
              labelText: textfield_label_unit_price,
              textEditingController: precioUnitarioController,
              isNumber: true,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _precioUnitarioError,
            ),
          ),
          Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_wholesale,
              labelText: textfield_label_wholesale,
              textEditingController: precioMayoreoController,
              isPassword: false,
              isNumber: true,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _precioMayoreoError,
            ),
          ),
          Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_stock,
              labelText: textfield_label_stock,
              textEditingController: stockController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              isNumber: true,
              errorText: _stockError,
            ),
          ),
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {
                _addProduct();
              },
              text: button_add_product,
              isDisabled: false,
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
          scanBarcodeNormal();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    businessId = args[business_id_args];
  }

  void _addProduct() async {
    _idError = null;
    _nombreError = null;
    _precioUnitarioError = null;
    _precioMayoreoError = null;
    _stockError = null;

    if (idController.text.isEmpty) {
      setState(() {
        _idError = "El ID no puede quedar vacío";
      });
      return;
    }

    if (nombreController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre no puede quedar vacío";
      });
      return;
    }

    if (precioUnitarioController.text.isEmpty) {
      setState(() {
        _precioUnitarioError = "El precio no puede quedar vacío";
      });
      return;
    }

    if (precioMayoreoController.text.isEmpty) {
      setState(() {
        _precioMayoreoError = "El precio no puede quedar vacío";
      });
      return;
    }

    if (stockController.text.isEmpty) {
      setState(() {
        _stockError = "El numero de existencias no puede quedar vacío";
      });
      return;
    }

    _product.id = idController.text.split(" ").first;
    _product.idNegocio = businessId!;
    _product.nombre = nombreController.text;
    _product.precioUnitario =
        double.parse(precioUnitarioController.text.split(" ").first);
    _product.precioMayoreo =
        double.parse(precioMayoreoController.text.split(" ").first);
    _product.stock = double.parse(stockController.text.split(" ").first);

    _businessDataSource
        .getProduct(businessId!, _product.id)
        .then((product) async => {
              if (product != null)
                {
                  _showToast("El Producto ya Existe"),
                }
              else
                {
                  if (await _businessDataSource.addProduct(
                      businessId!, _product))
                    {
                      _showToast("Registro de Producto Exitoso"),
                      _nextScreenArgs(optionsList_product_page, businessId!),
                    }
                  else
                    {
                      _showToast("Ha Ocurrido un Error"),
                    }
                }
            });
  }

  void scanQR() async {
    if (!mounted) return;

    idController.text = await _scanUtil.scanQR();
  }

  void scanBarcodeNormal() async {
    if (!mounted) return;

    idController.text = await _scanUtil.scanBarcodeNormal();
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
}
