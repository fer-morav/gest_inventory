import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/bloc/firebase/BusinessCubit.dart';
import 'package:gest_inventory/domain/bloc/firebase/ProductCubit.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/Product.dart';
import '../../ui/components/TextInputForm.dart';
import '../../data/models/Business.dart';
import '../../utils/custom_toast.dart';
import '../../utils/scan_util.dart';
import '../components/AppBarComponent.dart';
import '../components/MainButton.dart';

class SearchProductCodePage extends StatefulWidget {
  const SearchProductCodePage({Key? key}) : super(key: key);

  @override
  State<SearchProductCodePage> createState() => _SearchProductCodePageState();
}

class _SearchProductCodePageState extends State<SearchProductCodePage> {
  final _idProductController = TextEditingController();

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  String? businessId;
  Business? _business;
  bool _isLoading = true;

  ScanUtil _scanUtil = ScanUtil();

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
                    controller: _idProductController,
                    inputType: TextInputType.text,
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
    _idProductController.text = await ScanUtil.scanBarcodeNormal();
    if ((await BlocProvider.of<ProductCubit>(context).getProduct(
            _business!.id.toString(), _idProductController.text)) !=
        null) {
      final _product = await BlocProvider.of<ProductCubit>(context).getProduct(
          _business!.id.toString(), _idProductController.text);
      _nextScreenArgsProduct(product_route, _product!);
    } else {
      _showToast("Producto no registrado", false);
    }
  }

  void _nextScreenArgsProduct(String route, Product product) {
    final args = {product_args: product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Future<void> _searchProduct() async {
    String idProduct = _idProductController.text.split(" ").first;

    if (idProduct.isEmpty) {
      _showToast(alert_content_incomplete, false);
    } else {
      if ((await BlocProvider.of<ProductCubit>(context).getProduct(
              _business!.id.toString(), idProduct)) !=
          null) {
        final _product = await BlocProvider.of<ProductCubit>(context).getProduct(
            _business!.id.toString(), idProduct);
        _nextScreenArgsProduct(product_route, _product!);
      } else {
        _showToast("Código invalido", false);
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
    BlocProvider.of<BusinessCubit>(context).getBusiness(id).then((business) => {
          if (business != null)
            {
              setState(() {
                _business = business;
                _isLoading = false;
              }),
            }
        });
  }

  void _showToast(String message, bool status) {
    CustomToast.showToast(
      message: message,
      context: context,
      status: status,
    );
  }
}
