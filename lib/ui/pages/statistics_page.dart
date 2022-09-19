import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/Sales.dart';
import '../../utils/arguments.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../components/StatisticsComponent.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsState();
}

class _StatisticsState extends State<StatisticsPage> {
  final _padding = const EdgeInsets.only(
    left: 15,
    top: 5,
    right: 15,
    bottom: 5,
  );

  String? businessId;

  bool Order = true;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getArguments();
      // _fetchTips();
    });
    super.initState();
  }

  final sizeReference = 700.0;
  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        textAppBar: title_statistics,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? waitingConnection()
          : ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: _labelText(text_sort_by, 14),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: _labelText(
                        Order ? text_more_sold : text_less_sold,
                        20,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, right: 15),
                      child: FloatingActionButton(
                        backgroundColor: primaryColor,
                        mini: true,
                        onPressed: () {_setOrder();},
                        child: getIcon(AppIcons.change),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: _labelText(text_product, 14),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 60, top: 10),
                      child: _labelText(text_total_sales, 14),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15, top: 10),
                      child: _labelText(text_total_units, 14),
                    ),
                  ],
                ),
                Divider(
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                  color: primaryColor,
                ),
                StreamBuilder<List<Sales>>(
                  stream: null,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return hasError(text_connection_error);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return waitingConnection();
                    }
                    if (snapshot.data!.isEmpty) {
                      return hasError(text_empty_list);
                    }
                    if (snapshot.hasData) {
                      return _component(snapshot.data!);
                    }
                    return waitingConnection();
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

  // Stream<List<Sales>>? _fetchTips() {
  //   return BlocProvider.of<SalesCubit>(context).getSalesOrder(businessId!, Order);
  // }

  Widget _component(List<Sales> sales) {
    return ListView.builder(
      itemCount: sales.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: _padding,
          child: StatisticsComponent(
            sales: sales[index],
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

  void _setOrder() {
    setState(() {
      Order = !Order;
    });
  }

  Text _labelText(String text, double size) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: getResponsiveText(size),
      ),
    );
  }
}
