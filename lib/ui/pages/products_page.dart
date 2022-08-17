import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/bloc/firebase/ProductCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/routes.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String? _businessId;
  String? _userPosition;
  late Stream<List<Product>> _listProductStream;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getArguments();
      _listProductStream = BlocProvider.of<ProductCubit>(context).getProducts(_businessId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_allList_product,
        onPressed: () {
          Navigator.pop(context);
        },
        action: FloatingActionButton(
          child: getIcon(AppIcons.search),
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          _businessId == null
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
                      return _component(
                          snapshot.data!, _userPosition.toString());
                    }

                    return waitingConnection();
                  },
                ),
        ],
      ),
      floatingActionButton: _userPosition == "[Administrador]"
          ? FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () => _nextScreenArgs(add_product_page, _businessId!),
              backgroundColor: primaryColor,
              child: getIcon(AppIcons.add),
            )
          : null,
    );
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _businessId = args[business_id_args];
    _userPosition = args[user_position_args];

    setState(() {});
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {
      business_id_args: businessId,
    };

    Navigator.pushNamed(context, route, arguments: args);
  }

  Widget _component(List<Product> products, String usrPos) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductComponent(
          product: products[index],
          userPosition: usrPos,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: blackColor.withOpacity(0.75),
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
