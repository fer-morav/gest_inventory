import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/SalesDataSource.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/domain/bloc/MakeSaleCubit.dart';
import 'package:gest_inventory/ui/components/IconButton.dart';
import 'package:gest_inventory/ui/components/LoadingComponent.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../utils/custom_toast.dart';
import '../../utils/icons.dart';
import '../components/AppBarComponent.dart';
import '../components/DividerComponent.dart';
import '../components/MessageComponent.dart';
import '../components/SaleProductComponent.dart';
import '../components/search_product_delegate.dart';

class MakeSalePage extends StatefulWidget {
  const MakeSalePage({Key? key}) : super(key: key);

  @override
  State<MakeSalePage> createState() => _MakeSalePageState();
}

class _MakeSalePageState extends State<MakeSalePage> {
  final sizeReference = 700.0;

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MakeSaleCubit>(
      create: (_) => MakeSaleCubit(
        productRepository: ProductDataSource(),
        salesRepository: SalesDataSource(),
      )..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<MakeSaleCubit, MakeSaleState>(
          listener: (context, state) {
        if (state.message != null) {
          CustomToast.showToast(
            message: state.message!,
            context: context,
            status: state.status,
            gravity: ToastGravity.CENTER
          );
        }
      }, builder: (context, state) {
        final makeSaleBloc = context.read<MakeSaleCubit>();

        return Scaffold(
          appBar: AppBarComponent(
            textAppBar: title_make_sale,
            onPressed: () => pop(context),
          ),
          body: state.user == null
              ? LoadingComponent()
              : ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                      child: ButtonIcon(
                        isEnable: state.count > 0,
                        onPressed: () => _payProducts(makeSaleBloc),
                        text: button_paying_products,
                        icon: AppIcons.pay,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                      decoration: BoxDecoration(
                        color: adminColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$text_total: \$ ${state.total.toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryOnColor,
                          fontSize: getResponsiveText(25),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$text_products:',
                            style: TextStyle(
                              fontSize: getResponsiveText(25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            state.count.toString(),
                            style: TextStyle(
                              fontSize: getResponsiveText(25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.products.isEmpty
                        ? MessageComponent(text: text_empty_list)
                        : ListView.separated(
                            itemCount: state.products.keys.length,
                            shrinkWrap: true,
                            separatorBuilder: (_, int index) => DividerComponent(),
                            itemBuilder: (context, index) {

                              final product = state.products.keys.elementAt(index);
                              final value = state.products.values.elementAt(index);

                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) => _onDismissed(makeSaleBloc, product),
                                secondaryBackground: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  color: errorColor,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: getIcon(AppIcons.delete, color: primaryOnColor),
                                  ),
                                ),
                                key: UniqueKey(),
                                background: Container(
                                  color: primaryColor,
                                ),
                                child: SaleProductComponent(
                                  product: product,
                                  quantity: value,
                                  addTap: value < product.stock.toInt()
                                      ? () => makeSaleBloc.addProduct(product)
                                      : null,
                                  removeTap: value > 1
                                      ? () => makeSaleBloc.removeProduct(product)
                                      : null,
                                ),
                              );
                            },
                          ),
                  ],
                ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: AppIcons.list,
                child: getIcon(AppIcons.list, color: primaryOnColor),
                backgroundColor: primaryColor,
                onPressed: () => _selectProducts(makeSaleBloc),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                heroTag: AppIcons.scanner,
                child: getIcon(AppIcons.scanner, color: primaryOnColor),
                backgroundColor: primaryColor,
                onPressed: () => makeSaleBloc.scanBarcode(),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _selectProducts(MakeSaleCubit bloc) async {
    Product? product = await showSearch<Product?>(
      context: context,
      delegate: SearchProductDelegate(
        products: await bloc.listProducts(),
        actionType: ActionType.select,
      ),
    );

    if (product != null) {
      if (product.stock > 0) {
        bloc.addProduct(product);
      } else {
        CustomToast.showToast(message: text_product_not_available);
      }
    }
  }

  void _onDismissed(MakeSaleCubit bloc, Product product) {
    bloc.onDismissed(product);
    CustomToast.showToast(message: text_removed_product);
  }

  Future<void> _payProducts(MakeSaleCubit bloc) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => FutureProgressDialog(
        bloc.payProducts(),
      ),
    );
  }
}
