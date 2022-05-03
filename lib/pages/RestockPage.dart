import 'package:flutter/material.dart';
import 'package:gest_inventory/data/framework/FirebaseIncomingsSource.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import '../components/ButtonSecond.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/Business.dart';
import '../utils/scan_util.dart';
import 'package:gest_inventory/data/models/Incomings.dart';

class RestockPage extends StatefulWidget {
  const RestockPage({Key? key}) : super(key: key);

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  Incomings _incoming = Incomings(
    id: "",
    idNegocio: "",
    nombreProducto: "",
    precioUnitario: 0.0,
    precioMayoreo: 0.0,
    unidadesCompradas: 0.0,
  );

  TextEditingController idProductController = TextEditingController();
  TextEditingController newStockController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  late final FirebaseIncomingsDataSource _incomingsDataSource =
      FirebaseIncomingsDataSource();

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
        textAppBar: title_restock_product,
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
                  child: TextFieldMain(
                    hintText: textfield_hint_newStock_product,
                    labelText: textfield_label_newStock_product,
                    textEditingController: newStockController,
                    isPassword: false,
                    isPasswordTextStatus: false,
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
                    text: button_restock_product,
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
    } else {
      _showToast("Producto no registrado");
    }
  }

  Future<void> _searchProduct() async {
    String idproduct = idProductController.text.split(" ").first;
    double newStock = 0;
    double stock = 0;

    if (idproduct.isEmpty || newStockController.text.isEmpty) {
      _showToast(alert_content_imcomplete);
    } else {
      newStock = double.parse(newStockController.text);
      if (newStock < 1) {
        _showToast("Cantidad invalida");
      } else {
        if ((await _businessDataSource.getProduct(
                _business!.id.toString(), idproduct)) !=
            null) {
          final _product = await _businessDataSource.getProduct(
              _business!.id.toString(), idproduct);
          stock = _product!.stock;
          _product.stock = newStock + stock;
          if (_product != null &&
              await _businessDataSource.updateProduct(_product)) {

            final _prod = await _businessDataSource.getProduct(_product.idNegocio, _product.id);


            _incoming.id = _product.id;
            _incoming.idNegocio = _product.idNegocio;
            _incoming.nombreProducto = _product.nombre;
            _incoming.precioUnitario = _product.precioUnitario;
            _incoming.precioMayoreo = _product.precioMayoreo;
            _incoming.unidadesCompradas = newStock; //ingreso de unidades

            _incomingsDataSource.addIncoming(_incoming);//adición a la base de datos

            _showToast("Datos actualizados");
            Navigator.pop(context);
          } else {
            _showToast("Error al actualizar los datos");
          }
        } else {
          _showToast("Código invalido");
        }
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
