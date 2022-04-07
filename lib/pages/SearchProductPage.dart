import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../components/ButtonSecond.dart';
import '../components/TextFieldMain.dart';
import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({Key? key}) : super(key: key);

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );


  TextEditingController nombreController = TextEditingController();
  String? _nombreError;

  String? businessId;
  Product? _product;
  late String product;
  Business? business;
  late Stream<List<Product>> _listProductStream;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      nombreController.text = "";
      _listProductStream = _businessDataSource.getProducts(business!.id).asStream();
      //_listUsers();
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var _isSearching;
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Busqueda",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  padding: _padding,
                  child: TextFieldMain(
                    hintText: "Ingrese el nombre del producto",
                    labelText: "Ingrese el nombre del producto",
                    textEditingController: nombreController,
                    isPassword: false,
                    isPasswordTextStatus: false,
                    onTap: () {
                    },
                    errorText: _nombreError,
                  ),
                ),
                Container(
                  padding: _padding,
                  height: 80,
                  child: ButtonSecond(
                    onPressed:
                    _saveData,
                    //_nextScreenArgs(see_product_info_route, product),
                    text: "Buscar",
                  ),
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
    business= args["args"];
    setState(() {
      isLoading = false;
    });
  }

   _saveData() async {
     _businessDataSource.getProduct(business!.id,nombreController.text).then((product) => {
       if (product != null)
         {
           setState(() {
             _product = product;
             isLoading = false;
           }),
         }
       else
         {print(product?.id)}
     });
     _product.toString();
     nombreController.text = "";
     _nextScreenArgs(see_product_info_route, _product!);
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _nextScreenArgs(String route, Product product) {
    final args = {"args": product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Widget _component(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (contex, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ProductComponent(
            product: products[index],
          ),
        );
      },
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

  Center hasError(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
