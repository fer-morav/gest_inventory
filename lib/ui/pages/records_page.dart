import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/IncomingDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/SalesDataSource.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/domain/bloc/RecordsCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/data/models/Sales.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/MessageComponent.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/ui/components/TabBarComponent.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/colors.dart';
import '../../utils/enums.dart';
import '../../utils/icons.dart';
import '../../utils/navigator_functions.dart';
import '../components/HeaderPaintComponent.dart';
import '../components/ImageComponent.dart';
import '../components/RecordsComponent.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../components/pdf_gen.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({Key? key}) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final sizeReference = 700.0;

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  TextStyle _textStyle(double size, {Color color = primaryColor}) => TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: getResponsiveText(size),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordsCubit>(
      create: (_) => RecordsCubit(
          salesRepository: SalesDataSource(),
          incomingRepository: IncomingDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocBuilder<RecordsCubit, RecordsState>(
        builder: (context, state) {
          final recordsCubit = context.read<RecordsCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_report,
              onPressed: () => pop(context),
            ),
            body: state.product == null
                ? LoadingComponent()
                : ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: CustomPaint(
                          painter: HeaderPaintCurve(),
                          child: ImageComponent(
                            color: state.product!.stock.lowStocks()
                                ? adminColor
                                : employeeColor,
                            size: 120,
                            photoURL: state.product!.photoUrl,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        width: double.infinity,
                      ),
                      ListTile(
                        leading: Text(
                          text_sort_by_date,
                          textAlign: TextAlign.left,
                          style: _textStyle(18),
                        ),
                        title: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            state.descending ? text_most_recent : text_less_recent,
                            style: _textStyle(18),
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            color: primaryOnColor,
                            icon: getIcon(state.descending ? AppIcons.sort_amount_down : AppIcons.sort_amount_up),
                            onPressed: () => recordsCubit.setOrder(),
                          ),
                        ),
                      ),
                      Center(
                        child: DropdownButton<DateValues>(
                          style: _textStyle(18),
                          icon:
                              getIcon(AppIcons.arrow_down, color: primaryColor),
                          value: state.dateValues,
                          items: <DropdownMenuItem<DateValues>>[
                            DropdownMenuItem(
                              value: DateValues.year,
                              child: Text(button_alls),
                            ),
                            DropdownMenuItem(
                              value: DateValues.today,
                              child: Text(button_today),
                            ),
                            DropdownMenuItem(
                              value: DateValues.week,
                              child: Text(button_week),
                            ),
                            DropdownMenuItem(
                              value: DateValues.month,
                              child: Text(button_month),
                            ),
                          ],
                          onChanged: (value) => {
                            if (value != null) {recordsCubit.setValues(value)}
                          },
                        ),
                      ),
                      DividerComponent(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: TabBarComponent(
                          tabs: [
                            Tab(
                              text: text_sale,
                              icon: getIcon(AppIcons.price),
                            ),
                            Tab(
                              text: text_incoming,
                              icon: getIcon(AppIcons.add_product),
                            ),
                          ],
                          tabsView: [
                            StreamBuilder<List<Sales>>(
                              stream: recordsCubit.listSales,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return MessageComponent(text: text_error_connection);
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return LoadingComponent();
                                }
                                if (snapshot.data == null || snapshot.data!.isEmpty) {
                                  return MessageComponent(text: text_empty_list);
                                }
                                if (snapshot.hasData) {
                                  return _componentSales(snapshot.data!);
                                }

                                return LoadingComponent();
                              },
                            ),
                            StreamBuilder<List<Incoming>>(
                              stream: recordsCubit.listIncoming,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return MessageComponent(text: text_error_connection);
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return LoadingComponent();
                                }
                                if (snapshot.data == null || snapshot.data!.isEmpty) {
                                  return MessageComponent(text: text_empty_list);
                                }
                                if (snapshot.hasData) {
                                  return _componentIncoming(snapshot.data!);
                                }

                                return LoadingComponent();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
              heroTag: AppIcons.gen_pdf,
              backgroundColor: primaryColor,
              onPressed: () {},
              child: getIcon(AppIcons.gen_pdf, color: primaryOnColor),
            ),
          );
        },
      ),
    );
  }

  Widget _componentSales(List<Sales> sales) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sales.length,
      itemBuilder: (context, index) {
        return RecordsComponent(
          values: sales[index].toMap(),
        );
      },
    );
  }

  Widget _componentIncoming(List<Incoming> incoming) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: incoming.length,
      itemBuilder: (context, index) {
        return RecordsComponent(
          values: incoming[index].toMap(),
          sales: false,
        );
      },
    );
  }

// Future<void> _genPDF()async {
//   PdfDocument document = PdfDocument();
//   document.pageSettings.margins.all = 30;
//   final page = document.pages.add();
//   String currentDate = DateFormat.yMMMd().format(DateTime.now());
//
//   PdfBrush solidBrush = PdfSolidBrush(PdfColor(0,68,107));
//   PdfBrush dividerBrush = PdfSolidBrush(PdfColor(192,192,192));
//   Rect header = Rect.fromLTWH(0, 0, page.graphics.clientSize.width, 100);
//   Rect divider = Rect.fromLTWH(0, 101, page.graphics.clientSize.width, 3);
//   PdfFont subHeaderFont = PdfStandardFont(PdfFontFamily.timesRoman, 18);
//
//   String bussines_name = "Negocio: $businessName",
//   admin_name = "Administrador: $businessAdmin",
//   printing_date = "Fecha de Impresión: $currentDate";
//
//   PdfTextElement titulo = PdfTextElement(text: title_sales_report, font: PdfStandardFont(PdfFontFamily.timesRoman, 30));
//   titulo.draw(page: page, bounds: Rect.fromLTWH(10, header.top + 2, 0, 0))!;
//
//   PdfTextElement bsName = PdfTextElement(text: bussines_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
//   PdfTextElement adm_name = PdfTextElement(text: admin_name, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
//   PdfTextElement print_date = PdfTextElement(text: printing_date, font: PdfStandardFont(PdfFontFamily.timesRoman, 18));
//   bsName.draw(page: page, bounds: Rect.fromLTWH(10, 35, 0, 0))!;
//   adm_name.draw(page: page, bounds: Rect.fromLTWH(10, 55, 0, 0))!;
//   print_date.draw(page: page, bounds: Rect.fromLTWH(10, 75, 0, 0))!;
//   page.graphics.drawImage(
//     PdfBitmap(await _readImageData('gi-blue.png')),
//     Rect.fromLTWH(400, 0, 132, 99)
//   );
//
//   page.graphics.drawRectangle(brush: dividerBrush, bounds: divider);
//
//   PdfGrid grid = PdfGrid();
//   grid.columns.add(count: 8);
//   grid.headers.add(1);
//   PdfGridRow headerTab = grid.headers[0];
//   headerTab.cells[0].value = 'ID Negocio';
//   headerTab.cells[1].value = 'ID Producto';
//   headerTab.cells[2].value = 'Nombre Producto';
//   headerTab.cells[3].value = 'Precio Mayoreo';
//   headerTab.cells[4].value = 'Precio Unitario';
//   headerTab.cells[5].value = 'Total Actual';
//   headerTab.cells[6].value = 'Ventas por Mayoreo';
//   headerTab.cells[7].value = 'Ventas por Unitario';
//
//   PdfGridCellStyle headerStyle = PdfGridCellStyle();
//     headerStyle.borders.all = PdfPen(PdfColor(0,68,107));
//     headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(0,68,107));
//     headerStyle.textBrush = PdfBrushes.white;
//     headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,style: PdfFontStyle.regular);
//
//   for (int i = 0; i < headerTab.cells.count; i++) {
//     if (i == 0 || i == 1) {
//       headerTab.cells[i].stringFormat = PdfStringFormat(
//         alignment: PdfTextAlignment.left,
//         lineAlignment: PdfVerticalAlignment.middle);
//     } else {
//       headerTab.cells[i].stringFormat = PdfStringFormat(
//         alignment: PdfTextAlignment.right,
//         lineAlignment: PdfVerticalAlignment.middle);
//     }
//     headerTab.cells[i].style = headerStyle;
//   }
//
//   // PdfGridRow row = grid.rows.add();
//   // for(int i=0;i<_listSales.length;i++){//Renglones = 5
//   //   row.cells[0].value = _listSales[i].idNegocio;
//   //   row.cells[1].value = _listSales[i].id;
//   //   row.cells[2].value = _listSales[i].nombreProducto;
//   //   row.cells[3].value = "\$"+_listSales[i].precioMayoreo.toString();
//   //   row.cells[4].value = "\$"+_listSales[i].precioUnitario.toString();
//   //   row.cells[5].value = "\$"+_listSales[i].total.toString(); total = total + _listSales[i].total;
//   //   row.cells[6].value = _listSales[i].ventasMayoreo.toString();
//   //   row.cells[7].value = _listSales[i].ventasUnitario.toString();
//   //   row = grid.rows.add();
//   // }
//
//   grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);
//
//   PdfGridCellStyle cellStyle = PdfGridCellStyle();
//   cellStyle.borders.all = PdfPens.white;
//   cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
//   cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
//   cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//
//   for (int i = 0; i < grid.rows.count; i++) {
//     PdfGridRow row = grid.rows[i];
//     for (int j = 0; j < row.cells.count; j++) {
//       row.cells[j].style = cellStyle;
//       if (j == 0 || j == 1) {
//         row.cells[j].stringFormat = PdfStringFormat(
//         alignment: PdfTextAlignment.left,
//         lineAlignment: PdfVerticalAlignment.middle);
//       } else {
//         row.cells[j].stringFormat = PdfStringFormat(
//         alignment: PdfTextAlignment.right,
//         lineAlignment: PdfVerticalAlignment.middle);
//       }
//     }
//   }
//
//   PdfLayoutFormat layoutFormat = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);
//
//   PdfLayoutResult gridResult = grid.draw(
//     page: page,
//     bounds: Rect.fromLTWH(0, divider.top+10,
//       page.graphics.clientSize.width, page.graphics.clientSize.height - 100),
//     format: layoutFormat)!;
//
//   gridResult.page.graphics.drawString(
//     'Total General:              \$$total', subHeaderFont,
//     brush: PdfSolidBrush(PdfColor(126, 155, 203)),
//     bounds: Rect.fromLTWH(page.graphics.clientSize.width-220, gridResult.bounds.bottom + 30, 0, 0));
//
//   List<int> bytes=document.save();
//   document.dispose();
//
//   saveAndLaunchPDF(bytes, '$currentDate-$title_sales_report.pdf');
//   total=0.0;
// }
//
// Future<Uint8List> _readImageData(String name)async{
//   final data = await rootBundle.load('lib/assets/$name');
//   return data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
// }
}
