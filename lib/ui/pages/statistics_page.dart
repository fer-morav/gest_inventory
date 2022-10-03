import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/IncomingDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/SalesDataSource.dart';
import 'package:gest_inventory/domain/bloc/StatisticsCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/MessageComponent.dart';
import 'package:gest_inventory/ui/components/TabBarComponent.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/Incoming.dart';
import '../../data/models/Product.dart';
import '../../data/models/Sales.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../components/LoadingComponent.dart';
import '../components/StatisticsComponent.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsPage> {
  final sizeReference = 700.0;

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  TextStyle _textStyle(double size, {Color color = primaryColor}) => TextStyle(
    color: color,
    fontWeight: FontWeight.w500,
    fontSize: getResponsiveText(size),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(
          productRepository: ProductDataSource(),
          salesRepository: SalesDataSource(),
          incomingRepository: IncomingDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          final statisticsBloc = context.read<StatisticsCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_statistics,
              onPressed: () => pop(context),
            ),
            body: state.user == null
                ? LoadingComponent()
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton<DateValues>(
                              style: _textStyle(20),
                              icon: getIcon(AppIcons.arrow_down, color: primaryColor),
                              value: state.dateValues,
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
                                if (value != null)
                                  {statisticsBloc.setDateValues(value)}
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                color: primaryOnColor,
                                icon: getIcon(state.descending ? AppIcons.sort_down : AppIcons.sort_up),
                                onPressed: () => statisticsBloc.setOrder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.82,
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
                            StreamBuilder<Map<Product, List<Sales>>?>(
                              stream: statisticsBloc.listSalesProduct,
                              builder: (context, snapshot) {
                                return Scaffold(
                                  appBar: AppBar(
                                    elevation: 0,
                                    backgroundColor: primaryOnColor,
                                    bottom: PreferredSize(
                                      preferredSize: Size(double.infinity, 90),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 30),
                                            child: Text(state.descending ? text_more_sold : text_less_sold,
                                              style: _textStyle(20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  text_product,
                                                  style: _textStyle(15),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 60),
                                                  child: Text(
                                                    text_total_sales,
                                                    style: _textStyle(16),
                                                  ),
                                                ),
                                                Text(
                                                  text_total_units,
                                                  style: _textStyle(16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DividerComponent(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  body: snapshot.hasError
                                      ? MessageComponent(text: text_connection_error)
                                      : snapshot.data == null
                                          ? MessageComponent(text: text_empty_list)
                                          : snapshot.data!.isEmpty
                                              ? LoadingComponent()
                                              : _componentSales(snapshot.data!),
                                );
                              },
                            ),
                            StreamBuilder<Map<Product, List<Incoming>>?>(
                              stream: statisticsBloc.listIncomingProduct,
                              builder: (context, snapshot) {
                                return Scaffold(
                                  appBar: AppBar(
                                    elevation: 0,
                                    backgroundColor: primaryOnColor,
                                    bottom: PreferredSize(
                                      preferredSize: Size(double.infinity, 90),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 30),
                                            child: Text(state.descending ? text_most_entry : text_less_entry,
                                              style: _textStyle(20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  text_product,
                                                  style: _textStyle(16),
                                                ),
                                                Text(
                                                  text_total_units,
                                                  style: _textStyle(16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DividerComponent(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  body: snapshot.hasError
                                      ? MessageComponent(text: text_connection_error)
                                      : snapshot.data == null
                                          ? MessageComponent(text: text_empty_list)
                                          : snapshot.data!.isEmpty
                                              ? LoadingComponent()
                                              : _componentIncoming(snapshot.data!),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _componentSales(Map<Product, List<Sales>> sales) {
    return ListView.builder(
      itemCount: sales.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        List<int> values = [];

        sales.values
            .elementAt(index)
            .forEach((element) => values.add(element.units.toInt()));

        return StatisticsComponent(
          values: values,
          product: sales.keys.elementAt(index),
        );
      },
    );
  }

  Widget _componentIncoming(Map<Product, List<Incoming>> incoming) {
    return ListView.builder(
      itemCount: incoming.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        List<int> values = [];

        incoming.values
            .elementAt(index)
            .forEach((element) => values.add(element.units.toInt()));

        return StatisticsComponent(
          values: values,
          product: incoming.keys.elementAt(index),
          sales: false,
        );
      },
    );
  }
}
