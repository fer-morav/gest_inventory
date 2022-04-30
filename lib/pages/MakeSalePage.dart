import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/data/framework/FirebaseBusinessDataSource.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/routes.dart';
import 'package:gest_inventory/utils/scan_util.dart';
import 'package:gest_inventory/utils/strings.dart';
import 'package:gest_inventory/utils/resources.dart';
import '../components/ButtonMain.dart';
import '../components/TextFieldMain.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:gest_inventory/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';

// librerias de PDF
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../utils/pdf_gen.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
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
  String? businessId;
  ScanUtil _scanUtil = ScanUtil();

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

  List<String> litems = [];
  late List<Product> listProduct=[];
  final TextEditingController eCtrl = new TextEditingController();
  final sizeReference = 700.0;
  String? _nombreError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_make_sale,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: [
          Container(
            padding: _padding,
            height: 80,
            child: ButtonMain(
              onPressed: () {
                //_payProduct();
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
                    color: litems.length > 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            child: FittedBox(
              child: Text(
                litems.length > 0 ? text_in_cart : text_empty_cart,
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
              itemCount: litems.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int Index) {
                final item = litems[Index];
                return Dismissible(
                  onDismissed: (_) {
                    litems.removeAt(Index);
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
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Transform.scale(
                            scale: 1.6,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color:
                                listProduct[Index].stock.toString() == "0.0" ? Colors.redAccent : Colors.greenAccent,
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            listProduct[Index].nombre,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "\$ "+listProduct[Index].precioUnitario.toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "1 Unidad",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: getResponsiveText(17)
                            ),
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
              }
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
          SizedBox(height: 5), 
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
          FloatingActionButton(
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: primaryColor,
              size: 35,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              _createPDF(); 
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
    setState(() {});
  }

  void _addProduct() async {
    litems.add(idController.text);
    idController.clear();
    setState(() {});
    _showToast(text_added_product);
  }

  void scanQR() async {
    if (!mounted) return;

    idController.text = await _scanUtil.scanQR();
  }

  void scanBarcodeNormal() async {
    idController.text = await _scanUtil.scanBarcodeNormal();
    if( (await _businessDataSource.getProduct(businessId!, idController.text)) != null ){
      final _product = await _businessDataSource.getProduct(businessId!, idController.text);
      if(_product!.stock != 0.0){
        listProduct.add(_product);
        _addProduct();
      }else{
        _showToast(text_product_not_avilable); 
      }
    }else{
      _showToast(text_unregistered_product);
    }
    if (!mounted) return;
  }

  void DialogSearchByName(){
    showDialog(
      context: context,
      builder: (buildContext){
        return AlertDialog(
          title: Text(text_search_by_name),
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
            ButtonMain(
              onPressed: () {
                Navigator.of(context).pop();
                searchByName();
              },
              text: button_search,
              isDisabled: false,
            ),
          ],
        );
      }
    );
  }

  void searchByName(){
    _businessDataSource
        .getProductForName(businessId!, nameController.text)
        .then((product) => {
              if (product != null)
                {
                  if(product.stock != 0.0){
                    listProduct.add(product),
                    _addProduct(),
                  }else{
                    _showToast(text_product_not_avilable),
                  }
                }
              else
                {
                  _showToast(text_product_not_found),
                }
          });
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

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Text _labelText(String text, bool right) {
    return Text(
      text,
      textAlign: right ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: right ? Colors.black87 : primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;
  

  Future<void> _createPDF()async {
    PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 30;
    final page = document.pages.add();
    String currentDate = DateFormat.yMMMd().format(DateTime.now());

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(0,68,107));
    PdfBrush dividerBrush = PdfSolidBrush(PdfColor(192,192,192));
    Rect header = Rect.fromLTWH(0, 0, page.graphics.clientSize.width, 100);
    Rect divider = Rect.fromLTWH(0, 101, page.graphics.clientSize.width, 3);
    PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.timesRoman, 18);

    //STRINGS
    String title_report = "Reporte de Ventas",
          bussines_name = "Negocio: $businessId",
          admin_name = "Administrador: $businessId",
          printing_date = "Fecha de Impresión: $currentDate";

    //page.graphics.drawRectangle(brush: solidBrush, bounds: header);
    PdfTextElement titulo = PdfTextElement(text: title_report, font: PdfStandardFont(PdfFontFamily.timesRoman, 30));
    titulo.draw(page: page, bounds: Rect.fromLTWH(10, header.top + 2, 0, 0))!;

    PdfTextElement bsName = PdfTextElement(text: bussines_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    PdfTextElement adm_name = PdfTextElement(text: admin_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    PdfTextElement print_date = PdfTextElement(text: printing_date, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    bsName.draw(page: page, bounds: Rect.fromLTWH(10, 35, 0, 0))!;
    adm_name.draw(page: page, bounds: Rect.fromLTWH(10, 55, 0, 0))!;
    print_date.draw(page: page, bounds: Rect.fromLTWH(10, 75, 0, 0))!;
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('SVG_GI_AZUL.png')),
      Rect.fromLTWH(400, 0, 132, 99)
    );

    page.graphics.drawRectangle(brush: dividerBrush, bounds: divider);

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 8);
    grid.headers.add(1);
    PdfGridRow headerTab = grid.headers[0];
    headerTab.cells[0].value = 'ID Producto';
    headerTab.cells[1].value = 'ID Negocio';
    headerTab.cells[2].value = 'Nombre Producto';
    headerTab.cells[3].value = 'Precio Mayoreo';
    headerTab.cells[4].value = 'Precio Unitario';
    headerTab.cells[5].value = 'Total de Venta';    
    headerTab.cells[6].value = 'Venta en Mayoreo';
    headerTab.cells[7].value = 'Venta en Unidades';

    PdfGridCellStyle headerStyle = PdfGridCellStyle();
      headerStyle.borders.all = PdfPen(PdfColor(0,68,107));
      headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(0,68,107));
      headerStyle.textBrush = PdfBrushes.white;
      headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,style: PdfFontStyle.regular);

    for (int i = 0; i < headerTab.cells.count; i++) {
      if (i == 0 || i == 1) {
        headerTab.cells[i].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle);
      } else {
        headerTab.cells[i].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.right,
          lineAlignment: PdfVerticalAlignment.middle);
      }
      headerTab.cells[i].style = headerStyle;
    }

    PdfGridRow row = grid.rows.add();
    for(int i=0;i<40;i++){//Renglones = 5
      row.cells[0].value = listProduct[0].id;
      row.cells[1].value = listProduct[0].idNegocio;
      row.cells[2].value = listProduct[0].nombre;
      row.cells[3].value = '\$ '+listProduct[0].precioMayoreo.toString();
      row.cells[4].value = '\$ '+listProduct[0].precioUnitario.toString();
      row.cells[5].value = '\$ 50.00';
      row.cells[6].value = '0';
      row.cells[7].value = '10';
      row = grid.rows.add();
    }

    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));

    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.right,
          lineAlignment: PdfVerticalAlignment.middle);
        }
    }
}

PdfLayoutFormat layoutFormat =
    PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
PdfLayoutResult gridResult = grid.draw(
    page: page,
    bounds: Rect.fromLTWH(0, divider.top+10,
        page.graphics.clientSize.width, page.graphics.clientSize.height - 100),
    format: layoutFormat)!;

gridResult.page.graphics.drawString(
    'Grand Total :              \$386.91', subHeaderFont,
    brush: PdfSolidBrush(PdfColor(126, 155, 203)),
    bounds: Rect.fromLTWH(page.graphics.clientSize.width-220, gridResult.bounds.bottom + 30, 0, 0));

gridResult.page.graphics.drawString(
    'Thank you for your business !', subHeaderFont,
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(page.graphics.clientSize.width-220, gridResult.bounds.bottom + 60, 0, 0));

    
    List<int> bytes=document.save();
    document.dispose();

    saveAndLaunchPDF(bytes, '$title_report.pdf');
  }

  Future<Uint8List> _readImageData(String name)async{
    final data = await rootBundle.load('lib/assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
  }
}
