import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/firebase/ProductCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/scan_util.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/custom_toast.dart';
import '../components/MainButton.dart';
import '../components/TextInputForm.dart';

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

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceUnitController = TextEditingController();
  final _priceWholeSaleController = TextEditingController();
  final _stockController = TextEditingController();

  String? _idError;
  String? _nombreError;
  String? _precioUnitarioError;
  String? _precioMayoreoError;
  String? _stockError;

  String? businessId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceUnitController.dispose();
    _priceWholeSaleController.dispose();
    _stockController.dispose();
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
          TextInputForm(
            hintText: textfield_hint_id,
            labelText: textfield_label_id,
            controller: _idController,
            inputType: TextInputType.text,
            onTap: () {},
            errorText: _idError,
          ),
          TextInputForm(
            hintText: textfield_hint_name,
            labelText: textfield_label_name,
            controller: _nameController,
            inputType: TextInputType.text,
            onTap: () {},
            errorText: _nombreError,
          ),
          TextInputForm(
            hintText: textfield_hint_unit_price,
            labelText: textfield_label_unit_price,
            controller: _priceUnitController,
            inputType: TextInputType.number,
            onTap: () {},
            errorText: _precioUnitarioError,
          ),
          TextInputForm(
            hintText: textfield_hint_wholesale,
            labelText: textfield_label_wholesale,
            controller: _priceWholeSaleController,
            inputType: TextInputType.number,
            onTap: () {},
            errorText: _precioMayoreoError,
          ),
          TextInputForm(
            hintText: textfield_hint_stock,
            labelText: textfield_label_stock,
            controller: _stockController,
            inputType: TextInputType.number,
            onTap: () {},
            errorText: _stockError,
          ),
          Container(
            padding: _padding,
            height: 80,
            child: MainButton(
              onPressed: () {
                _addProduct();
              },
              text: button_add_product,
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

    if (_idController.text.isEmpty) {
      setState(() {
        _idError = "El ID no puede quedar vacío";
      });
      return;
    }

    if (_nameController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre no puede quedar vacío";
      });
      return;
    }

    if (_priceUnitController.text.isEmpty) {
      setState(() {
        _precioUnitarioError = "El precio no puede quedar vacío";
      });
      return;
    }

    if (_priceWholeSaleController.text.isEmpty) {
      setState(() {
        _precioMayoreoError = "El precio no puede quedar vacío";
      });
      return;
    }

    if (_stockController.text.isEmpty) {
      setState(() {
        _stockError = "El numero de existencias no puede quedar vacío";
      });
      return;
    }

    Product product = Product(
      id: _idController.text.trim(),
      businessId: businessId!,
      name: _nameController.text.trim(),
      unitPrice: double.parse(_priceUnitController.text.trim()),
      wholesalePrice: double.parse(_priceWholeSaleController.text.trim()),
      stock: double.parse(_stockController.text.trim()),
    );

    final result = await showDialog(
      context: context,
      builder: (_) => FutureProgressDialog(
        BlocProvider.of<ProductCubit>(context).getProduct(businessId!, product.id),
      ),
    );

    if (result != null) {
      _showToast(text_already_registered_product, false);
      return;
    }

    if (await BlocProvider.of<ProductCubit>(context).addProduct(businessId!, product) != null) {
      _showToast(text_registered_product, true);
      //_nextScreenArgs(optionsList_product_page, businessId!);
    } else {
      _showToast(alert_title_error_general + ' ' + alert_content_error_general, false);
    }
  }

  void scanQR() async {
    if (!mounted) return;
    _idController.text = await ScanUtil.scanQR();
  }

  void scanBarcodeNormal() async {
    if (!mounted) return;

    _idController.text = await ScanUtil.scanBarcodeNormal();
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.popAndPushNamed(context, route, arguments: args);
  }
}
