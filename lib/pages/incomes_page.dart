import 'package:flutter/material.dart';
import 'package:gest_inventory/components/AppBarComponent.dart';
import 'package:gest_inventory/components/IncomingsComponent.dart';
import 'package:gest_inventory/data/models/Incomings.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../data/framework/FirebaseIncomingsSource.dart';
import '../utils/colors.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../components/pdf_gen.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({Key? key}) : super(key: key);

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {

  late final FirebaseIncomingDataSource _incomingsDataSource = FirebaseIncomingDataSource();

  String? businessId, businessName, businessAdmin;
  late Future<List<Incomings>> _listIncomingsStream;
  late List<Incomings> _listIncomings;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getArguments();
      _listIncomingsStream = _incomingsDataSource.getTableIncoming(businessId!);
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: "Historial de Entradas",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? waitingConnection()
          : FutureBuilder<List<Incomings>>(
              future: _listIncomingsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return hasError("Error de Conexión");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitingConnection();
                }
                if (snapshot.data!.isEmpty) {
                  return hasError("Historial Vacio");
                }
                if (snapshot.hasData) {
                  _listIncomings = snapshot.data!;
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
        onPressed: () {_genPDF();},
        child: Icon(Icons.archive_rounded),
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
    businessName = args[business_name_args];
    businessAdmin = args[business_nameadmin_args];
    setState(() {
      isLoading = false;
    });
  }

  void _nextScreenArgs(String route, String businessId) {
    final args = {business_id_args: businessId};
    Navigator.pushNamed(context, route, arguments: args);
  }

  Widget _component(List<Incomings> incomings) {
    return ListView.builder(
      itemCount: incomings.length,
      itemBuilder: (contex, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: IncomingsComponent(
            incomings: incomings[index],
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

  Future<void> _genPDF()async {
    PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 30;
    final page = document.pages.add();
    String currentDate = DateFormat.yMMMd().format(DateTime.now());

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(0,68,107));
    PdfBrush dividerBrush = PdfSolidBrush(PdfColor(192,192,192));
    Rect header = Rect.fromLTWH(0, 0, page.graphics.clientSize.width, 100);
    Rect divider = Rect.fromLTWH(0, 101, page.graphics.clientSize.width, 3);
    PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.timesRoman, 18);

    String bussines_name = "Negocio: $businessName",
    admin_name = "Administrador: $businessAdmin",
    printing_date = "Fecha de Impresión: $currentDate";

    PdfTextElement titulo = PdfTextElement(text: title_incomings_report, font: PdfStandardFont(PdfFontFamily.timesRoman, 30));
    titulo.draw(page: page, bounds: Rect.fromLTWH(10, header.top + 2, 0, 0))!;

    PdfTextElement bsName = PdfTextElement(text: bussines_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    PdfTextElement adm_name = PdfTextElement(text: admin_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    PdfTextElement print_date = PdfTextElement(text: printing_date, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
    bsName.draw(page: page, bounds: Rect.fromLTWH(10, 35, 0, 0))!;
    adm_name.draw(page: page, bounds: Rect.fromLTWH(10, 55, 0, 0))!;
    print_date.draw(page: page, bounds: Rect.fromLTWH(10, 75, 0, 0))!;
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('gi-blue.png')),
      Rect.fromLTWH(400, 0, 132, 99)
    );

    page.graphics.drawRectangle(brush: dividerBrush, bounds: divider);

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 6);
    grid.headers.add(1);
    PdfGridRow headerTab = grid.headers[0];
    headerTab.cells[0].value = 'ID Negocio';
    headerTab.cells[1].value = 'ID Producto';
    headerTab.cells[2].value = 'Nombre Producto';
    headerTab.cells[3].value = 'Precio Mayoreo';
    headerTab.cells[4].value = 'Precio Unitario';
    headerTab.cells[5].value = 'Unidades Compradas';

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
    for(int i=0;i<_listIncomings.length;i++){//Renglones = 5
      row.cells[0].value = _listIncomings[i].idNegocio;
      row.cells[1].value = _listIncomings[i].id;
      row.cells[2].value = _listIncomings[i].nombreProducto;
      row.cells[3].value = "\$"+_listIncomings[i].precioMayoreo.toString();
      row.cells[4].value = "\$"+_listIncomings[i].precioUnitario.toString();
      row.cells[5].value = _listIncomings[i].unidadesCompradas.toString();
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

    PdfLayoutFormat layoutFormat = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

    PdfLayoutResult gridResult = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, divider.top+10,
        page.graphics.clientSize.width, page.graphics.clientSize.height - 100),
      format: layoutFormat)!;

    List<int> bytes=document.save();
    document.dispose();

    saveAndLaunchPDF(bytes, "$currentDate-$title_incomings_report.pdf");
  }

  Future<Uint8List> _readImageData(String name)async{
    final data = await rootBundle.load('lib/assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
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
}
