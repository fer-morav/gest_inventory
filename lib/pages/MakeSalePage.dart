import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/ButtonSecond.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/framework/FirebaseSalesDataSource.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/scan_util.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import '../data/models/Sales.dart';
import 'package:intl/intl.dart';

class MakeSalePage extends StatefulWidget {
  const MakeSalePage({Key? key}) : super(key: key);

  @override
  State<MakeSalePage> createState() => _MakeSalePageState();
}

class _MakeSalePageState extends State<MakeSalePage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 10,
    right: 15,
    bottom: 10,
  );

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FirebaseBusinessDataSource _businessDataSource = FirebaseBusinessDataSource();
  FirebaseSalesDataSource _salesDataSource = FirebaseSalesDataSource();

  ScanUtil _scanUtil = ScanUtil();

  String? businessId;
  String? _nombreError;
  double total = 0.0;

  List<String> listItems = [];
  late List<Product> listProduct = [];

  final sizeReference = 700.0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _getArguments();
    });
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_make_sale,
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
                  height: 80,
                  child: ButtonMain(
                    onPressed: () {
                      isLoading = true;
                      _payProduct();
                      Navigator.pop(context);
                    },
                    text: button_paying_products,
                    isDisabled: false,
                  ),
                ),
                Container(
                  height: 35,
                  margin: const EdgeInsets.only(
                    left: 80,
                    top: 10,
                    right: 80,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: listItems.length > 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FittedBox(
                    child: Text(
                      listItems.length > 0 ? text_in_cart : text_empty_cart,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: listItems.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        final item = listItems[Index];
                        return Dismissible(
                          onDismissed: (_) {
                            listItems.removeAt(Index);
                            listProduct.removeAt(Index);
                            _showToast(text_removed_product);
                            setState(() {});
                          },
                          movementDuration: Duration(milliseconds: 100),
                          key: Key(item),
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 15),
                                  child: Transform.scale(
                                    scale: 1.6,
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color:
                                          listProduct[Index].stock.toString() ==
                                                  "0.0"
                                              ? Colors.redAccent
                                              : Colors.greenAccent,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    listProduct[Index].nombre,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: getResponsiveText(17)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "\$ " +
                                        listProduct[Index]
                                            .precioUnitario
                                            .toString(),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: getResponsiveText(17)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Stock: " +
                                        listProduct[Index].stock.toString(),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: getResponsiveText(17)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          background: Container(
                            color: primaryColor,
                          ),
                        );
                      }),
                ),

                Container(
                  height: 35,
                  margin: const EdgeInsets.only(
                    left: 80,
                    top: 10,
                    right: 80,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: listItems.length > 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FittedBox(
                    child: Text(
                      listItems.length > 0 ? "TOTAL: \$ "+ total.toString() : "TOTAL: \$ 0.0" ,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),

              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(
              Icons.qr_code_scanner,
              color: primaryColor,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              scanBarcodeNormal();
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(
              Icons.abc_sharp,
              color: primaryColor,
              size: 35,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              DialogSearchByName();
            },
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
    businessId = args[business_id_args];

    setState(() {
      isLoading = false;
    });
  }

  bool inStock(Product product) {
    int count = 0;
    listItems.forEach((element) {
      if (product.id == element) {
        count++;
      }
    });
    if (count < product.stock) {
      return true;
    } else {
      return false;
    }
  }

  void _addProduct(String id) async {
    listItems.add(id);
    idController.clear();
    nameController.clear();
    setState(() {});
    _showToast(text_added_product);
  }

  void scanQR() async {
    if (!mounted) return;

    idController.text = await _scanUtil.scanQR();
  }

  void scanBarcodeNormal() async {
    idController.text = await _scanUtil.scanBarcodeNormal();
    if ((await _businessDataSource.getProduct(
            businessId!, idController.text)) !=
        null) {
      final _product =
          await _businessDataSource.getProduct(businessId!, idController.text);
      if (_product!.stock != 0.0 && inStock(_product)) {

        listProduct.add(_product);

        total = total + _product.precioUnitario;

        _addProduct(_product.id);
      } else {
        _showToast(text_product_not_avilable);
      }
    } else {
      _showToast(text_unregistered_product);
    }
    if (!mounted) return;
  }

  void searchByName(String name) {
    _businessDataSource.getProductForName(businessId!, name).then(
          (product) => {
            if (product != null)
              {
                if (product.stock != 0.0 && inStock(product))
                  {

                  total = total + product.precioUnitario,

                    listProduct.add(product),
                    _addProduct(product.id),
                  }
                else
                  {
                    _showToast(text_product_not_avilable),
                  }
              }
            else
              {
                _showToast(text_product_not_found),
              }
          },
        );
  }

  void DialogSearchByName() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return AlertDialog(
          title: Text(
            text_search_by_name,
            textAlign: TextAlign.center,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          content: Container(
            padding: _padding,
            child: TextFieldMain(
              hintText: textfield_hint_name_product,
              labelText: textfield_label_name_product,
              textEditingController: nameController,
              isPassword: false,
              isPasswordTextStatus: false,
              onTap: () {},
              errorText: _nombreError,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      nameController.clear();
                    },
                    child: Text(
                      button_cancel,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ButtonSecond(
                    onPressed: () {
                      Navigator.of(context).pop();
                      searchByName(nameController.text);
                      nameController.clear();
                    },
                    text: button_search,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _payProduct() {
    setState(() {
      isLoading = true;
    });
    List<String> paid = [];
    listProduct.forEach((product) async {

      if(!paid.contains(product.id)){
        await _payPrice(product,  quantityProduct(product.id));
        paid.add(product.id);
      }

    });
  }

  int quantityProduct(String id) {
    int cont = 0;
    listItems.forEach((element) {
      if(element == id) {
        cont++;
      }
    });
    return cont;
  }

  _payPrice(Product product, int quantity) async {
    Sales? sale = await _salesDataSource.getSale(businessId!, product.id);
    if (sale != null) {
      Map<String, num> changes;

      if (quantity >= 10) {
        changes = {
          Sales.VENTAS_MAYOREO: sale.ventasMayoreo + quantity,
          Sales.TOTAL: sale.total + (sale.precioMayoreo * quantity)
        };
      } else {
        changes = {
          Sales.VENTAS_UNITARIO: sale.ventasUnitario + quantity,
          Sales.TOTAL: sale.total + (sale.precioUnitario * quantity)
        };
      }

      if (await _salesDataSource.updateSale(businessId!, sale.id, changes)) {
        product.stock -= quantity;
        await _businessDataSource.updateProduct(product);
      }

    } else {

      final sale = Sales(
        id: product.id,
        idNegocio: product.idNegocio,
        nombreProducto: product.nombre,
        precioUnitario: product.precioUnitario,
        precioMayoreo: product.precioMayoreo,
        ventasUnitario: quantity < 10 ? quantity : 0,
        ventasMayoreo: quantity >= 10 ? quantity : 0,
        total: quantity < 10
            ? product.precioUnitario * quantity
            : product.precioMayoreo * quantity,
      );
      if (await _salesDataSource.addSale(sale)) {
        product.stock -= quantity;
        await _businessDataSource.updateProduct(product);
      }
    }
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

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

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
