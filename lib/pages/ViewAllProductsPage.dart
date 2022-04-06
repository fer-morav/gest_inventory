import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonMain.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/strings.dart';

class ViewAllProductsPage extends StatefulWidget {
  const ViewAllProductsPage({Key? key}) : super(key: key);

  @override
  State<ViewAllProductsPage> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewAllProductsPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

    String id = "123546";
    String idNegocio = "123456789";
    String nombre = "Paracetamol";
    String nombre2 = "Ibuprofeno";
    double precioUnitario = 35.0;
    double precioUnitario2 = 50.45;
    double precioMayoreo = 30.0;
    double precioMayoreo2 = 47.20;
    double stock = 125.0;
    double stock2 = 40.0;
    int ventaSemana = 12;
    int ventaSemana2 = 2;
    int ventaMes = 50;
    int ventaMes2 = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Productos",
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: const Text.rich(
              TextSpan(
                text: "Información de los Productos",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(1000, 0, 68, 106),
                ),
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 60,
            child:Text(
              "Nombre: " + nombre.toString() ,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Precio Unitario: " + precioUnitario.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Precio Mayoreo: " + precioMayoreo.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Unidades Restantes: " + stock.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Ventas Semanales: " + ventaSemana.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Ventas Mensuales: " + ventaMes.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          Container(
            padding: _padding,
            height: 60,
            child:Text(
              "Nombre: " + nombre2.toString() ,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Precio Unitario: " + precioUnitario2.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Precio Mayoreo: " + precioMayoreo2.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Unidades Restantes: " + stock2.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Ventas Semanales: " + ventaSemana2.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: _padding,
            height: 45,
            child: Text(
              "Ventas Mensuales: " + ventaMes2.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromARGB(1000, 0, 68, 106),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              text: "Confirmar",
              isDisabled: true,
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }

  void _nextScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}
