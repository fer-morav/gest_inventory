import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/datasource/firebase/StorageDataSource.dart';
import 'package:gest_inventory/ui/components/ProgressDialogComponent.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import 'package:gest_inventory/utils/strings.dart';
import '../../domain/bloc/ProductCubit.dart';
import '../../utils/actions_enum.dart';
import '../../utils/arguments.dart';
import '../../utils/colors.dart';
import '../../utils/custom_toast.dart';
import '../../utils/icons.dart';
import '../../utils/routes.dart';
import '../components/AppBarComponent.dart';
import '../components/HeaderPaintComponent.dart';
import '../components/IconButton.dart';
import '../components/ImageComponent.dart';
import '../components/ImageProfileComponent.dart';
import '../components/ProfilePictureMenu.dart';
import '../components/TextInputForm.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (_) => ProductCubit(
          productRepository: ProductDataSource(),
          storageRepository: StorageDataSource(),
      )..init(ModalRoute.of(context)?.settings.arguments as Map),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.message != null) {
            CustomToast.showToast(
              message: state.message!,
              context: context,
              status: state.error,
            );
          }
          if (state.message == text_update_data ||
              state.message == text_add_product_success) {
            pop(context);
          }
        },
        builder: (context, state) {
          final bloc = context.read<ProductCubit>();

          return Scaffold(
            appBar: AppBarComponent(
              textAppBar: title_product,
              onPressed: () => pop(context),
            ),
            body: state.user == null
                ? ProgressDialogComponent()
                : ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: CustomPaint(
                          painter: HeaderPaintCurve(),
                          child: state.actionType == ActionType.add ||
                                  state.actionType == ActionType.edit
                              ? ImageProfileComponent(
                                  admin: true,
                                  image: state.profilePhoto,
                                  onPressed: () => _showProfileMenuPhoto(bloc),
                                )
                              : ImageComponent(
                                  color: state.product!.stock.lowStocks() ? adminColor : employeeColor,
                                  size: 120,
                                  photoURL: state.product!.photoUrl,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextInputForm(
                              hintText: textfield_hint_id,
                              labelText: textfield_label_id,
                              controller: bloc.barcodeController,
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.text,
                              barcode: true,
                              onTap: () => bloc.scanBarcode(),
                              validator: (barcode) => bloc.validatorBarcode(barcode),
                              readOnly: state.actionType == ActionType.open,
                            ),
                            TextInputForm(
                              hintText: textfield_hint_name,
                              labelText: textfield_label_name,
                              controller: bloc.nameController,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              onTap: () {},
                              validator: (name) => bloc.validatorName(name),
                              readOnly: state.actionType == ActionType.open,
                            ),
                            TextInputForm(
                              hintText: textfield_hint_description,
                              labelText: textfield_label_description,
                              controller: bloc.descriptionController,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              onTap: () {},
                              validator: (description) => bloc.validatorDescription(description),
                              readOnly: state.actionType == ActionType.open,
                            ),
                            TextInputForm(
                              hintText: textfield_hint_unit_price,
                              labelText: textfield_label_unit_price,
                              controller: bloc.unitPriceController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              salary: true,
                              onTap: () {},
                              validator: (price) => bloc.validatorPrice(price),
                              readOnly: state.actionType == ActionType.open,
                            ),
                            TextInputForm(
                              hintText: textfield_hint_wholesale,
                              labelText: textfield_label_wholesale,
                              controller: bloc.wholesalePriceController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              salary: true,
                              onTap: () {},
                              validator: (price) => bloc.validatorPrice(price),
                              readOnly: state.actionType == ActionType.open,
                            ),
                            TextInputForm(
                              hintText: textfield_hint_stock,
                              labelText: textfield_label_stock,
                              controller: bloc.stockController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.done,
                              onTap: () {},
                              validator: (stock) => bloc.validatorStock(stock),
                              readOnly: state.actionType == ActionType.open,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: state.actionType != ActionType.open,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 80,
                          child: ButtonIcon(
                            onPressed: () {
                              if (_formKey.currentState?.validate() == true) {
                                _registerProduct(bloc);
                              }
                            },
                            text: state.actionType == ActionType.edit
                                ? button_save
                                : button_add_product,
                            icon: state.actionType == ActionType.edit
                                ? AppIcons.save
                                : AppIcons.add_product,
                          ),
                        ),
                      ),
                    ],
                  ),
            floatingActionButton: Visibility(
              visible: state.actionType == ActionType.open && state.user!.admin,
              child: FloatingActionButton(
                onPressed: () => bloc.setActionType(ActionType.edit),
                backgroundColor: primaryColor,
                child: getIcon(AppIcons.edit),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProfileMenuPhoto(ProductCubit bloc) async {
    String? result = await showDialog(
      context: context,
      builder: (_) {
        return ProfilePictureMenu();
      },
    );

    if (result == null || result.isEmpty) {
      return;
    }

    bloc.setProfilePhoto(result);
  }

  void _registerProduct(ProductCubit bloc) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => FutureProgressDialog(
        bloc.registerProduct(),
      ),
    );
  }
}
