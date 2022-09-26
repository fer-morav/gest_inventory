import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/Business.dart';
import '../../utils/custom_toast.dart';
import '../components/AppBarComponent.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import '../components/MainButton.dart';
import '../components/TextInputForm.dart';

class RestockPage extends StatefulWidget {
  const RestockPage({Key? key}) : super(key: key);

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  Incoming _incoming = Incoming(
    id: "",
    units: 0.0,
    creationDate: Timestamp.now()
  );

  final _idProductController = TextEditingController();
  final _newStockController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  String? businessId;
  Business? _business;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
                  child: TextInputForm(
                    hintText: textfield_hint_product,
                    labelText: textfield_label_product,
                    controller: _idProductController,
                    inputType: TextInputType.text,
                    onTap: () {},
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: TextInputForm(
                    hintText: textfield_hint_stock,
                    labelText: textfield_label_stock,
                    controller: _newStockController,
                    inputType: TextInputType.number,
                    onTap: () {},
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: MainButton(
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
    // _idProductController.text = await ScanUtil.scanBarcodeNormal();
    // if ((await BlocProvider.of<ProductCubit>(context).getProduct(
    //         _business!.id.toString(), _idProductController.text)) !=
    //     null) {
    //   await BlocProvider.of<ProductCubit>(context).getProduct(
    //       _business!.id.toString(), _idProductController.text);
    // } else {
    //   _showToast("Producto no registrado", false);
    // }
  }

  Future<void> _searchProduct() async {
    // String idProduct = _idProductController.text.split(" ").first;
    // double newStock = 0;
    // double stock = 0;
    //
    // if (idProduct.isEmpty || _newStockController.text.isEmpty) {
    //   _showToast(alert_content_incomplete, false);
    // } else {
    //   newStock = double.parse(_newStockController.text);
    //   if (newStock < 1) {
    //     _showToast("Cantidad invalida", false);
    //   } else {
    //     if ((await BlocProvider.of<ProductCubit>(context).getProduct(
    //             _business!.id.toString(), idProduct)) !=
    //         null) {
    //       final _product = await BlocProvider.of<ProductCubit>(context).getProduct(
    //           _business!.id.toString(), idProduct);
    //       stock = _product!.stock;
    //       _product.stock = newStock + stock;
    //       if (await BlocProvider.of<ProductCubit>(context).updateProduct(_product)) {
    //
    //         await BlocProvider.of<ProductCubit>(context).getProduct(_product.businessId, _product.id);
    //
    //
    //         _incoming.id = _product.id;
    //         _incoming.idNegocio = _product.businessId;
    //         _incoming.nombreProducto = _product.name;
    //         _incoming.precioUnitario = _product.unitPrice;
    //         _incoming.precioMayoreo = _product.wholesalePrice;
    //         _incoming.unidadesCompradas = newStock;
    //
    //         BlocProvider.of<IncomingCubit>(context).addIncoming(_incoming);
    //
    //         _showToast("Datos actualizados", true);
    //         Navigator.pop(context);
    //       } else {
    //         _showToast("Error al actualizar los datos", false);
    //       }
    //     } else {
    //       _showToast("Código invalido", false);
    //     }
    //   }
    // }
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
    // BlocProvider.of<BusinessCubit>(context).getBusiness(id).then((business) => {
    //       if (business != null)
    //         {
    //           setState(() {
    //             _business = business;
    //             _isLoading = false;
    //           }),
    //         }
    //     });
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }
}