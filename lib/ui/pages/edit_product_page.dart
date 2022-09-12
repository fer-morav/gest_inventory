import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/domain/bloc/firebase/BusinessCubit.dart';
import 'package:gest_inventory/domain/bloc/firebase/ProductCubit.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/colors.dart';
import '../../utils/custom_toast.dart';
import '../components/AppBarComponent.dart';
import '../components/MainButton.dart';
import '../components/TextInputForm.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() =>
      _EditProductState();
}

class _EditProductState extends State<EditProductPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioMayoreoController = TextEditingController();
  TextEditingController precioUnitarioController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController ventaMesController = TextEditingController();
  TextEditingController ventaSemanaController = TextEditingController();

  late String idNegocio, negocio;
  String? product;
  Product? _product;
  Business? _business;

  String? _nombreError;
  String? _precioMayoreoError;
  String? _precioUnitarioError;
  String? _stockError;
  String? _ventaSemanaError;
  String? _ventaMesError;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getArguments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_edit_product,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                TextInputForm(
                  hintText: textfield_label_name_product,
                  labelText: textfield_label_name_product,
                  controller: nombreController,
                  inputType: TextInputType.name,
                  onTap: () {},
                  errorText: _nombreError,
                ),
                TextInputForm(
                  hintText: textfield_label_unit,
                  labelText: textfield_label_unit,
                  controller: precioUnitarioController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _precioUnitarioError,
                ),
                TextInputForm(
                  hintText: textfield_label_wholesale,
                  labelText: textfield_label_wholesale,
                  controller: precioMayoreoController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _precioMayoreoError,
                ),
                TextInputForm(
                  hintText: textfield_label_stock,
                  labelText: textfield_label_stock,
                  controller: stockController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _stockError,
                ),
                TextInputForm(
                  hintText: textfield_sale_week,
                  labelText: textfield_sale_week,
                  controller: ventaSemanaController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _ventaSemanaError,
                ),
                TextInputForm(
                  hintText: textfield_sale_month,
                  labelText: textfield_sale_month,
                  controller: ventaMesController,
                  inputType: TextInputType.number,
                  onTap: () {},
                  errorText: _ventaMesError,
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: MainButton(
                    onPressed: _saveData,
                    text: button_save,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _getArguments() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _product = args[product_args];

    nombreController.text = _product!.name;
    precioMayoreoController.text = _product!.wholesalePrice.toString();
    precioUnitarioController.text = _product!.unitPrice.toString();
    stockController.text = _product!.stock.toString();

    idNegocio = _product!.businessId.toString();

    Business result = await showDialog(
      context: context,
      builder: (_) => FutureProgressDialog(
        BlocProvider.of<BusinessCubit>(context).getBusiness(idNegocio),
      ),
    );

    _business = result;
    negocio = _business!.name;
    _isLoading = false;

    setState(() {});
  }

  void _saveData() async {
    _nombreError = null;
    _precioMayoreoError = null;
    _precioUnitarioError = null;
    _stockError = null;
    _ventaSemanaError = null;
    _ventaMesError = null;

    if (nombreController.text.isEmpty) {
      setState(() {
        _nombreError = "El nombre del producto no puede quedar vacío";
      });

      return;
    }

    if (precioMayoreoController.text.isEmpty) {
      setState(() {
        _precioMayoreoError = "El precio de mayoreo no puede quedar vacío";
      });

      return;
    }

    if (precioUnitarioController.text.isEmpty) {
      setState(() {
        _precioUnitarioError = "El precio unitario no puede quedar vacío";
      });

      return;
    }

    if (stockController.text.isEmpty) {
      setState(() {
        _stockError = "El stock no puede quedar vacío";
      });

      return;
    }

    if (ventaMesController.text.isEmpty) {
      setState(() {
        _ventaMesError = "Las ventas al mes no puede quedar vacía";
      });

      return;
    }

    if (ventaSemanaController.text.isEmpty) {
      setState(() {
        _ventaSemanaError = "Las ventas a la semana no puede quedar vacía";
      });

      return;
    }

    setState(() {
      _isLoading = true;
    });

    _product?.name = nombreController.text;
    _product?.wholesalePrice = double.parse(precioMayoreoController.text);
    _product?.unitPrice = double.parse(precioUnitarioController.text);
    _product?.stock = double.parse(stockController.text);

    if (_product != null && await BlocProvider.of<ProductCubit>(context).updateProduct(_product!)) {
      _showToast(text_update_data, true);
      //_nextScreenArgs(optionsList_product_page, _product!.idNegocio);
    } else {
      _showToast(text_error_update_data, false);
    }
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.popAndPushNamed(context, route, arguments: args);
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }

  Center waitingConnection() {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        width: 75,
        height: 75,
      ),
    );
  }
}
