import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/AppBarComponent.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import '../data/models/User.dart';
import '../utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';

class SeeInfoProductPage extends StatefulWidget {
  const SeeInfoProductPage({Key? key}) : super(key: key);

  @override
  State<SeeInfoProductPage> createState() => _SeeInfoProductPageState();
}

class _SeeInfoProductPageState extends State<SeeInfoProductPage> {
  late String nombre, precioMayoreo, precioUnitario, stock, ventaMes, ventaSemana, idNegocio, negocio;

  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  late final FirebaseBusinessDataSource _businessDataSource =
      FirebaseBusinessDataSource();

  bool _isLoading = true;
  Product? _product;
  Business? _business;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getArguments();
      //_getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_info_product,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: _isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Container(
                  height: 80,
                  padding: _padding,
                  child: Transform.scale(
                    scale: 3.5,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: stock.toString() == "0.0"
                          ? Colors.redAccent
                          : Colors.greenAccent,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(
                    left: 80,
                    top: 10,
                    right: 80,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: stock.toString() == "0.0"
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FittedBox(
                    child: Text(
                      stock.toString() == "0.0" ? "No Disponible" : "Disponible",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Producto: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    _product!.nombre.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Precio Unitario: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "\$ "+_product!.precioUnitario.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Precio Mayoreo: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "\$ "+_product!.precioMayoreo.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Stock: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    _product!.stock.toString()+" Unidades",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    "Disponible en: ",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color.fromARGB(1000, 0, 68, 106),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Text(
                    _business!.nombreNegocio.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ventas esta semana: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        _product!.ventaSemana.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: _padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ventas este mes: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        _product!.ventaMes.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _nextScreenArgs(modify_product_route, _product!),//Cambiar por edicion de informacion
        child: Icon(Icons.edit_outlined),
      ),
    );
  }

  void _nextScreenArgs(String route, Product product) {
    final args = {product_args: product};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _getArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _product = args[product_args];

    nombre = _product!.nombre;
    precioMayoreo = _product!.precioMayoreo.toString();
    precioUnitario = _product!.precioUnitario.toString();
    stock = _product!.stock.toString();
    ventaMes = _product!.ventaMes.toString();
    ventaSemana = _product!.ventaSemana.toString();
    idNegocio = _product!.idNegocio.toString();

    _businessDataSource.getBusiness(idNegocio).then((business) => {
          if (business != null)
            {
              setState(() {
                _business = business;
                negocio = _business!.nombreNegocio.toString();
                _isLoading = false;
              }),
            }
          else
            {print(business?.id)}
        });
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
