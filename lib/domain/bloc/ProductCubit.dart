import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';
import 'package:gest_inventory/domain/usecases/product/AddProductUseCase.dart';
import 'package:gest_inventory/domain/usecases/product/GetProductUseCase.dart';
import 'package:gest_inventory/domain/usecases/product/UpdateProductUseCase.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/arguments.dart';
import 'package:gest_inventory/utils/scan_util.dart';
import '../../data/models/Product.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractStorageRepository.dart';
import '../../utils/image_picker_utils.dart';
import '../../utils/resources.dart';
import '../../utils/strings.dart';
import '../usecases/storage/UploadProductPhotoUseCase.dart';

class ProductCubit extends Cubit<ProductState> {
  final AbstractProductRepository productRepository;
  final AbstractStorageRepository storageRepository;

  late AddProductUseCase _addProductUseCase;
  late GetProductUseCase _getProductUseCase;
  late UpdateProductUseCase _updateProductUseCase;
  late UploadProductPhotoUseCase _uploadProductPhotoUseCase;

  final _pickerUtils = ImagePickerUtils();

  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final unitPriceController = TextEditingController();
  final wholesalePriceController = TextEditingController();
  final stockController = TextEditingController();

  ProductCubit({
    required this.productRepository,
    required this.storageRepository,
  }) : super(ProductState());

  void init(Map<dynamic, dynamic> args) {
    _addProductUseCase = AddProductUseCase(productRepository: productRepository);
    _getProductUseCase = GetProductUseCase(productRepository: productRepository);
    _updateProductUseCase = UpdateProductUseCase(productRepository: productRepository);
    _uploadProductPhotoUseCase = UploadProductPhotoUseCase(storageRepository: storageRepository);

    if (args.isEmpty) {
      return;
    }

    _initValues(args);
  }

  void setActionType(ActionType action) => _newState(actionType: action);

  void _showToast(String message, bool error) =>
      _newState(message: message, error: error);

  String? validatorBarcode(String? value) =>
      value!.isEmpty ? textfield_error_barcode : null;

  String? validatorName(String? value) =>
      value!.isEmpty ? textfield_error_name : null;

  String? validatorDescription(String? value) =>
      value!.isEmpty ? textfield_error_description : null;

  String? validatorPrice(String? value) =>
      value!.isEmpty ? textfield_error_price : null;

  String? validatorStock(String? value) =>
      value!.isEmpty ? textfield_error_quantity : null;

  void scanBarcode() async {
    barcodeController.text = await ScanUtil.scanBarcodeNormal();
  }

  Future<void> setProfilePhoto(String response) async {
    switch (response) {
      case button_take_photo:
        final photoImage = await _pickerUtils.pickImageFromCamera();

        if (photoImage != null) {
          _newState(photoFile: photoImage, profilePhoto: FileImage(photoImage));
        }
        break;

      case button_pick_picture:
        final photoImage = await _pickerUtils.pickImageFromGallery();

        if (photoImage != null) {
          _newState(photoFile: photoImage, profilePhoto: FileImage(photoImage));
        }
        break;

      case button_delete_photo:
        _newState(
            photoFile: null,
            profilePhoto: NetworkImage(image_product_default));
        break;
    }
  }

  Future<void> registerProduct() async {
    if (state.actionType == ActionType.add) {
      _newState(
        product: Product(
          businessId: state.user!.idBusiness,
          barcode: barcodeController.text.trim(),
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          unitPrice: double.parse(unitPriceController.text.trim()),
          wholesalePrice: double.parse(wholesalePriceController.text.trim()),
          stock: double.parse(stockController.text.trim()),
        ),
      );

      String? id = await _addProduct();

      if (id == null) {
        _showToast(text_add_product_not_success, false);
      } else {
        _newState(product: state.product!.copyWith(id: id));

        await _uploadPhoto();

        _showToast(text_add_product_success, true);
      }
    } else {
      _newState(
        product: state.product!.copyWith(
          barcode: barcodeController.text.trim(),
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          unitPrice: double.parse(unitPriceController.text.trim()),
          wholesalePrice: double.parse(wholesalePriceController.text.trim()),
          stock: double.parse(stockController.text.trim()),
        ),
      );

      if (await _updateProduct()) {
        await _uploadPhoto();

        _showToast(text_update_data, true);
      } else {
        _showToast(text_error_update_data, false);
      }
    }
  }

  Future<String?> _addProduct() async {
    if (state.product != null) {
      return await _addProductUseCase.add(state.product!);
    }
    return null;
  }

  Future<bool> _updateProduct() async {
    if (state.product != null && state.product!.id.isNotEmpty) {
      if (await _updateProductUseCase.update(state.product!.id, state.product!.toMap())) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<void> _uploadPhoto() async {
    if (state.product != null &&
        state.product!.id.isNotEmpty &&
        state.photoFile != null) {

      final result = await _uploadProductPhotoUseCase.upload(state.product!.id, state.photoFile!);

      if (result == null) {
        _showToast(alert_error_load_image, false);
      } else {
        _updatePhotoUrl(result);
      }
    }
  }

  void _updatePhotoUrl(String photoUrl) async {
    if (state.product != null && state.product!.id.isNotEmpty) {
      final changes = {
        Product.FIELD_URL_PHOTOS: photoUrl,
      };

      await _updateProductUseCase.update(state.product!.id, changes);
    }
  }

  void _initValues(Map<dynamic, dynamic> args) {
    ActionType action = args[action_type_args];

    if (action == ActionType.add) {
      _newState(user: args[user_args], actionType: action);
      return;
    }

    if (action == ActionType.open) {
      Product product = args[product_args];

      _newState(user: args[user_args], product: product, actionType: action);

      _loadInfo(product);
      return;
    }
  }

  void _loadInfo(Product product) {
    _newState(profilePhoto: NetworkImage(product.photoUrl));

    barcodeController.text = product.barcode;
    nameController.text = product.name;
    descriptionController.text = product.description;
    unitPriceController.text = product.unitPrice.toString();
    wholesalePriceController.text = product.wholesalePrice.toString();
    stockController.text = product.stock.toString();
  }

  @override
  Future<void> close() {
    barcodeController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    unitPriceController.dispose();
    wholesalePriceController.dispose();
    stockController.dispose();
    return super.close();
  }

  void _newState({
    User? user,
    Product? product,
    ActionType? actionType,
    ImageProvider? profilePhoto,
    File? photoFile,
    String? message,
    bool? error,
  }) {
    emit(ProductState(
      user: user ?? state.user,
      product: product ?? state.product,
      actionType: actionType ?? state.actionType,
      profilePhoto: profilePhoto ?? state.profilePhoto,
      photoFile: photoFile ?? state.photoFile,
      message: message,
      error: error ?? state.error,
    ));
  }
}

class ProductState {
  final User? user;
  final Product? product;
  final ActionType actionType;
  final ImageProvider profilePhoto;
  final File? photoFile;
  final String? message;
  final bool error;

  ProductState({
    this.user = null,
    this.product = null,
    this.actionType = ActionType.select,
    this.profilePhoto = const NetworkImage(image_product_default),
    this.photoFile = null,
    this.message = null,
    this.error = false,
  });
}
