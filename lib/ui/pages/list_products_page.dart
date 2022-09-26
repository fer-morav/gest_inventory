import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/domain/bloc/ListProductsCubit.dart';
import 'package:gest_inventory/ui/components/AppBarComponent.dart';
import 'package:gest_inventory/ui/components/MessageComponent.dart';
import 'package:gest_inventory/ui/components/ProductComponent.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/ui/components/SpeedDialComponent.dart';
import 'package:gest_inventory/ui/components/search_product_delegate.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/User.dart';
import '../../utils/enums.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/navigator_functions.dart';
import '../../utils/routes.dart';
import '../components/DividerComponent.dart';
import '../components/LoadingComponent.dart';

class ListProductsPage extends StatefulWidget {
  const ListProductsPage({Key? key}) : super(key: key);

  @override
  State<ListProductsPage> createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListProductsCubit>(
      create: (_) => ListProductsCubit(productRepository: ProductDataSource())
        ..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocBuilder<ListProductsCubit, ListProductsState>(
        builder: (context, state) {
          final productsBloc = context.read<ListProductsCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_list_product,
              onPressed: () => pop(context),
              action: IconButton(
                icon: getIcon(AppIcons.search, size: 30),
                onPressed: () => _searchProduct(productsBloc),
              ),
            ),
            body: state.user == null
                ? LoadingComponent()
                : StreamBuilder<List<Product>>(
                    stream: productsBloc.listStreamProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return MessageComponent(text: text_connection_error);
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return MessageComponent(text: text_empty_list);
                      }
                      if (snapshot.hasData) {
                        return _component(snapshot.data!, productsBloc);
                      }

                      return LoadingComponent();
                    },
                  ),
            floatingActionButton: Visibility(
              visible: state.user != null && state.user!.admin,
              child: SpeedDialComponent(
                actionType: state.actionType,
                onPressed: state.actionType != ActionType.select
                    ? () => productsBloc.setAction(ActionType.select)
                    : null,
                children: [
                  SpeedDialChild(
                    onTap: () => productsBloc.setAction(ActionType.delete),
                    backgroundColor: primaryOnColor,
                    child: getIcon(AppIcons.delete, color: errorColor, size: 30),
                  ),
                  SpeedDialChild(
                    onTap: () => _nextScreen(state.user!, null, productsBloc),
                    backgroundColor: primaryOnColor,
                    child: getIcon(AppIcons.add, color: primaryColor, size: 30),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchProduct(ListProductsCubit bloc) async {
    if (bloc.state.user == null) {
      return;
    }

    Product? product = await showSearch<Product?>(
      context: context,
      delegate: SearchProductDelegate(
        products: await bloc.listProducts(),
        actionType: bloc.state.actionType,
      ),
    );

    if (product == null) {
      return;
    }

    switch(bloc.state.actionType) {
      case ActionType.select:
        _nextScreen(bloc.state.user!, product, bloc);
        break;
      case ActionType.delete:
        _deleteProduct(product, bloc);
        break;
      default:
        break;
    }
  }

  void _nextScreen(User user, Product? product, ListProductsCubit bloc) async {
    final args = {
      action_type_args: product == null ? ActionType.add : ActionType.open,
      user_args: user,
      product_args: product
    };

    pushNamedWithArgs(context, product_route, args);
  }

  Widget _component(List<Product> products, ListProductsCubit bloc) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: products.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return ProductComponent(
          product: products[index],
          actionType: bloc.state.actionType,
          onTap: () => bloc.state.actionType == ActionType.delete
              ? _deleteProduct(products[index], bloc)
              : _nextScreen(bloc.state.user!, products[index], bloc),
        );
      },
    );
  }

  Future<void> _deleteProduct(Product product, ListProductsCubit bloc) async {
    final result = await showOkCancelAlertDialog(
      title: title_confirm_delete,
      message: '$text_want_remove_product ${product.name}?',
      context: context,
      okLabel: button_yes,
      cancelLabel: button_no,
      barrierDismissible: false,
      isDestructiveAction: false,
      onWillPop: () async {
        return false;
      },
    );

    if (result == OkCancelResult.ok) {
      bloc.deleteProduct(product);
    }
  }
}
