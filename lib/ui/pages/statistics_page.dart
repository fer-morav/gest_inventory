import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/SalesDataSource.dart';
import 'package:gest_inventory/domain/bloc/StatisticsCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/DividerComponent.dart';
import 'package:gest_inventory/ui/components/MessageComponent.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
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
    fontWeight: FontWeight.w600,
    fontSize: getResponsiveText(size),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(
          productRepository: ProductDataSource(),
          salesRepository: SalesDataSource())
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
                      ListTile(
                        leading: Text(
                          text_sort_by,
                          textAlign: TextAlign.left,
                          style: _textStyle(20),
                        ),
                        title: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            state.descending ? text_more_sold : text_less_sold,
                            style: _textStyle(20),
                          ),
                        ),
                        trailing: FloatingActionButton(
                          child: getIcon(AppIcons.change),
                          backgroundColor: primaryColor,
                          onPressed: () => statisticsBloc.setOrder(),
                          mini: true,
                        ),
                      ),
                      Center(
                        child: DropdownButton<DateValues>(
                          style: _textStyle(18),
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
                                style: _textStyle(15),
                              ),
                            ),
                            Text(
                              text_total_units,
                              style: _textStyle(15),
                            ),
                          ],
                        ),
                      ),
                      DividerComponent(),
                      StreamBuilder<Map<Product, List<Sales>>>(
                        stream: statisticsBloc.getProductsSales(state.user!.idBusiness, state.dateValues),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return MessageComponent(text: text_connection_error);
                          }
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return MessageComponent(text: text_empty_list);
                          }
                          if (snapshot.hasData) {
                            return _component(snapshot.data!);
                          }

                          return LoadingComponent();
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _component(Map<Product, List<Sales>> sales) {
    return ListView.builder(
      itemCount: sales.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return StatisticsComponent(
          sales: sales.values.elementAt(index),
          product: sales.keys.elementAt(index),
        );
      },
    );
  }
}
