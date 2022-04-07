import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';

import '../data/framework/FirebaseAuthDataSource.dart';
import '../data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import '../utils/routes.dart';

class AllListProductsPage extends StatefulWidget {
  const AllListProductsPage({Key? key}) : super(key: key);

  @override
  State<AllListProductsPage> createState() => _AllListProductsPageState();
}

class _AllListProductsPageState extends State<AllListProductsPage> {
  final FirebaseAuthDataSource _authDataSource = FirebaseAuthDataSource();
  final FirebaseUserDataSouce _userDataSource = FirebaseUserDataSouce();
  late final FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();

  String? businessId;
  late Stream<List<Product>> _listProductStream;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      _listProductStream = _businessDataSource.getProducts(businessId!).asStream();
      //_listUsers();
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_allList_product,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? waitingConnection()
          : StreamBuilder<List<Product>>(
              stream: _listProductStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return hasError("Error de Conexion");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingConnection();
                }
                if (snapshot.data!.isEmpty) {
                  return hasError("Lista Vacia");
                }
                if (snapshot.hasData) {
                  return _component(snapshot.data!);
                }

                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _nextScreenArgs(add_product_page, businessId!),//Cambiar al de registrar producto
        child: Icon(Icons.add),
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
    setState(() {
      isLoading = false;
    });
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {businessId: businessId};
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
