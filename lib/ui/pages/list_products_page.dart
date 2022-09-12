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
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../data/models/User.dart';
import '../../utils/actions_enum.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/navigator_functions.dart';
import '../../utils/routes.dart';
import '../components/DividerComponent.dart';
import '../components/ProgressDialogComponent.dart';

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
      child: BlocConsumer<ListProductsCubit, ListProductsState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = context.read<ListProductsCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_list_product,
              onPressed: () => pop(context),
              action: IconButton(
                icon: getIcon(AppIcons.search, size: 30),
                onPressed: () {},
              ),
            ),
            body: state.user == null
                ? ProgressDialogComponent()
                : StreamBuilder<List<Product>>(
                    stream: bloc.listProducts(state.user!.idBusiness),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return MessageComponent(text: text_connection_error);
                      }
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return MessageComponent(text: text_empty_list);
                      }
                      if (snapshot.hasData) {
                        return _component(snapshot.data!, bloc);
                      }

                      return ProgressDialogComponent();
                    },
                  ),
            floatingActionButton: Visibility(
              visible: state.user != null && state.user!.admin,
              child: SpeedDialComponent(
                actionType: state.actionType,
                onPressed: state.actionType != ActionType.select
                    ? () => bloc.setAction(ActionType.select)
                    : null,
                children: [
                  SpeedDialChild(
                    onTap: () => bloc.setAction(ActionType.delete),
                    backgroundColor: primaryOnColor,
                    child: getIcon(AppIcons.delete, color: errorColor, size: 30),
                  ),
                  SpeedDialChild(
                    onTap: () => _nextScreen(state.user!, null),
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

  void _nextScreen(User user, Product? product) {
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
          onTap: () => _nextScreen(bloc.state.user!, products[index]),
        );
      },
    );
  }
}
