import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/data/datasource/firebase/IncomingDataSource.dart';
import 'package:gest_inventory/domain/bloc/RestockCubit.dart';
import 'package:gest_inventory/utils/colors.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/datasource/firebase/ProductDataSource.dart';
import '../../data/models/Product.dart';
import '../../utils/custom_toast.dart';
import '../../utils/enums.dart';
import '../../utils/icons.dart';
import '../../utils/navigator_functions.dart';
import '../components/AppBarComponent.dart';
import '../components/DividerComponent.dart';
import '../components/IconButton.dart';
import '../components/IncomingProductComponent.dart';
import '../components/LoadingComponent.dart';
import '../components/MessageComponent.dart';
import '../components/search_product_delegate.dart';

class RestockPage extends StatefulWidget {
  const RestockPage({Key? key}) : super(key: key);

  @override
  State<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends State<RestockPage> {
  final sizeReference = 700.0;

  double getResponsiveText(double size) =>
      size * sizeReference / MediaQuery.of(context).size.longestSide;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestockCubit>(
      create: (_) => RestockCubit(
        productRepository: ProductDataSource(),
        incomingRepository: IncomingDataSource(),
      )..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<RestockCubit, RestockState>(
        listener: (context, state) {
          if (state.message != null) {
            CustomToast.showToast(
                message: state.message!,
                context: context,
                status: state.status,
                gravity: ToastGravity.CENTER);
          }
        },
        builder: (context, state) {
          final makeIncomingBloc = context.read<RestockCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_restock_products,
              onPressed: () => pop(context),
            ),
            body: state.user == null
                ? LoadingComponent()
                : ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                        child: ButtonIcon(
                          isEnable: state.count > 0,
                          onPressed: () => _restockProducts(makeIncomingBloc),
                          text: button_restock_product,
                          icon: AppIcons.add_product,
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
                                  onDismissed: (_) => _onDismissed(makeIncomingBloc, product),
                                  secondaryBackground: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    color: errorColor,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: getIcon(AppIcons.delete,
                                          color: primaryOnColor),
                                    ),
                                  ),
                                  key: UniqueKey(),
                                  background: Container(
                                    color: primaryColor,
                                  ),
                                  child: IncomingProductComponent(
                                    product: product,
                                    quantity: value,
                                    addTap: () => makeIncomingBloc.addProduct(product),
                                    removeTap: value > 1
                                        ? () => makeIncomingBloc
                                            .removeProduct(product)
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
                  onPressed: () => _selectProducts(makeIncomingBloc),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: AppIcons.scanner,
                  child: getIcon(AppIcons.scanner, color: primaryOnColor),
                  backgroundColor: primaryColor,
                  onPressed: () => makeIncomingBloc.scanBarcode(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectProducts(RestockCubit bloc) async {
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

  void _onDismissed(RestockCubit bloc, Product product) {
    bloc.onDismissed(product);
    CustomToast.showToast(message: text_removed_product);
  }

  Future<void> _restockProducts(RestockCubit bloc) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => FutureProgressDialog(
        bloc.restockProducts(),
      ),
    );
  }
}
