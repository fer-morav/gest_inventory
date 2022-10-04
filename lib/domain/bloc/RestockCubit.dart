import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'package:gest_inventory/domain/usecases/incoming/AddIncomingUseCase.dart';
import 'package:gest_inventory/domain/usecases/product/UpdateStockUseCase.dart';
import 'package:gest_inventory/utils/arguments.dart';
import '../../data/models/Product.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractProductRepository.dart';
import '../../utils/custom_toast.dart';
import '../../utils/scan_util.dart';
import '../../utils/strings.dart';
import '../usecases/product/GetProductUseCase.dart';
import '../usecases/product/GetProductsUseCase.dart';

class RestockCubit extends Cubit<RestockState> {
  final AbstractProductRepository productRepository;
  final AbstractIncomingRepository incomingRepository;

  late GetProductUseCase _getProductUseCase;
  late GetProductsUseCase _getProductsUseCase;
  late UpdateProductStockUseCase _updateProductStockUseCase;
  late AddIncomingUseCase _addIncomingUseCase;

  final productsController = StreamController<Product>();
  late StreamSubscription _subscription;

  RestockCubit({
    required this.productRepository,
    required this.incomingRepository,
  }) : super(RestockState(products: {}));

  void init(Map<dynamic, dynamic> args) {
    _getProductUseCase = GetProductUseCase(productRepository: productRepository);
    _getProductsUseCase = GetProductsUseCase(productRepository: productRepository);
    _updateProductStockUseCase = UpdateProductStockUseCase(productRepository: productRepository);
    _addIncomingUseCase = AddIncomingUseCase(incomingRepository: incomingRepository);

    _newState(user: args[user_args]);

    _calculateTotal();
  }

  void _showToast(String message, bool error) => _newState(message: message, status: error);

  Future<List<Product>> listProducts() => _getProductsUseCase.getList(state.user!.idBusiness);

  void addProduct(Product product) {
    if (state.products[product] != null) {
      state.products[product] = state.products.update(
        product,
            (value) => value < product.stock ? value + 1 : value,
      );
    } else {
      state.products[product] = 1;
    }

    productsController.add(product);

    _newState(products: state.products);
  }

  void removeProduct(Product product) {
    if (state.products[product] != null) {
      state.products[product] = state.products.update(product, (value) => value - 1);

      productsController.add(product);

      _newState(products: state.products);
    }
  }

  void onDismissed(Product product) {
    state.products.remove(product);

    productsController.add(product);

    _newState(products: state.products);
  }

  void scanBarcode() async {
    String barcode = await ScanUtil.scanBarcodeNormal();

    final product = await _getProductUseCase.get(state.user!.idBusiness, barcode);

    if (product != null && product.stock > 0) {
      addProduct(product);
    } else {
      CustomToast.showToast(message: text_product_not_available);
    }
  }

  Future<void> restockProducts()  async {
    state.products.forEach((product, value)  async {
      final incoming = Incoming(
        units: value.toDouble(),
        creationDate: Timestamp.now(),
      );

      if (await _addIncomingUseCase.add(product.id, incoming)) {
        if (await _updateProductStockUseCase.update(product.id, value, increment: true)) {
          _showToast(text_register_product, true);
        }
      }
    });

    _newState(products: {}, count: 0);
  }

  void _calculateTotal() {
    _subscription = productsController.stream.listen((product) {
      var count = 0;

      state.products.forEach((product, quantity) => {
        count += quantity
      });

      _newState(count: count);
    });
  }

  void _newState({
    User? user,
    Map<Product, int>? products,
    int? count,
    String? message,
    bool? status,
  }) {
    emit(RestockState(
      user: user ?? state.user,
      products: products ?? state.products,
      count: count ?? state.count,
      message: message,
      status: status ?? state.status,
    ));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

class RestockState {
  final User? user;
  final Map<Product, int> products;
  final int count;
  final String? message;
  final bool status;

  RestockState({
    this.user = null,
    required this.products,
    this.count = 0,
    this.message = null,
    this.status = false,
  });
}
