import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/IncomingDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/SalesDataSource.dart';
import 'package:gest_inventory/domain/bloc/InformCubit.dart';
import 'package:gest_inventory/ui/components/DataTableComponent.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/ui/components/ProductInfoComponent.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import '../../utils/colors.dart';
import '../../utils/enums.dart';
import '../../utils/icons.dart';
import '../../utils/strings.dart';

class InformPage extends StatefulWidget {
  const InformPage({Key? key}) : super(key: key);

  @override
  State<InformPage> createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
  final sizeReference = 700;

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  TextStyle _textStyle(double size, {Color color = primaryColor}) => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: getResponsiveText(size),
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InformCubit>(
      create: (_) => InformCubit(
        productRepository: ProductDataSource(),
        salesRepository: SalesDataSource(),
        incomingRepository: IncomingDataSource(),
      )..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocBuilder<InformCubit, InformState>(
        builder: (context, state) {
          final informBloc = context.read<InformCubit>();

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => pop(context),
                  icon: getIcon(
                    AppIcons.arrow_back,
                    size: 30,
                  ),
                ),
                title: FittedBox(
                  child: Align(
                    child: Text(
                      title_inform,
                      style: TextStyle(
                        color: primaryOnColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                actions: [
                  DropdownButton<DateValues>(
                    dropdownColor: primaryColor,
                    style: _textStyle(20, color: primaryOnColor),
                    icon: getIcon(AppIcons.arrow_down, color: primaryOnColor),
                    value: state.dateValues,
                    borderRadius: BorderRadius.circular(10),
                    items: <DropdownMenuItem<DateValues>>[
                      DropdownMenuItem(
                        value: DateValues.year,
                        child: Text(button_all),
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
                      if (value != null && mounted) {informBloc.setDateValues(value)}
                    },
                  ),
                ],
                bottom: TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  labelStyle: _textStyle(18),
                  indicatorWeight: 3,
                  indicatorColor: primaryOnColor,
                  labelColor: primaryOnColor,
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
                ),
              ),
              body: state.user == null
                  ? LoadingComponent()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SafeArea(
                            child: SingleChildScrollView(
                              child: Row(
                                children: [
                                  DataTableComponent(
                                    columns: [
                                      DataColumn(
                                        label: Text(text_product),
                                      ),
                                    ],
                                    rows: [
                                      ...state.salesProducts.map(
                                        (data) => DataRow(
                                          cells: [
                                            DataCell(
                                              ProductInfoComponent(product: data.product),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(primaryColor),
                                        cells: [
                                          DataCell(Container()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTableComponent(
                                        currentSortColumn: state.currentSortColumnSales,
                                        isAscending: state.ascendingSales,
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_unit_price),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_price),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_unit_sold),
                                            ),
                                            numeric: true,
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_wholesale_sold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_total),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          ...state.salesProducts.map(
                                            (data) => DataRow(
                                              cells: [
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '\$ ${data.product.unitPrice}',
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '\$ ${data.product.wholesalePrice}',
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '${data.unitSold}',
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '${data.wholeSaleSold}',
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '\$ ${data.total}',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataRow(
                                            color: MaterialStateProperty.all(primaryColor),
                                            cells: [
                                              DataCell(Container()),
                                              DataCell(
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(
                                                    '$text_total:',
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    informBloc.totalUnitSold().toString(),
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    informBloc.totalWholeSaleSold().toString(),
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    '\$ ${informBloc.totalSales().toString()}',
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            child: SingleChildScrollView(
                              child: Row(
                                children: [
                                  DataTableComponent(
                                    columns: [
                                      DataColumn(
                                        label: Text(text_product),
                                      ),
                                    ],
                                    rows: [
                                      ...state.entriesProducts.map(
                                        (data) => DataRow(
                                          cells: [
                                            DataCell(
                                              ProductInfoComponent(
                                                  product: data.product),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataRow(
                                        color: MaterialStateProperty.all(primaryColor),
                                        cells: [
                                          DataCell(Container()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTableComponent(
                                        columns: [
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_stock),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(text_incoming),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          ...state.entriesProducts.map(
                                            (data) => DataRow(
                                              cells: [
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '${data.product.stock}',
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                      '${data.unitsEntries}',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataRow(
                                            color: MaterialStateProperty.all(primaryColor),
                                            cells: [
                                              DataCell(
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    '$text_total:',
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    informBloc.totalEntries().toString(),
                                                    style: _textStyle(
                                                      20,
                                                      color: primaryOnColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                heroTag: AppIcons.gen_pdf,
                backgroundColor: primaryColor,
                onPressed: () {},
                child: getIcon(AppIcons.gen_pdf, color: primaryOnColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
