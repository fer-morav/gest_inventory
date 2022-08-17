import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';

class ProductCubit extends Cubit<ProductState> {
  final AbstractProductRepository _productRepository;
  Product? _product;

  ProductCubit(this._productRepository) : super(ProductInitialState());

  Future<void> reset() async => emit(ProductInitialState());

  Future<Product?> getProduct(String businessId, String productId) async {
    _product = await _productRepository.getProduct(businessId, productId);
    emit(ProductReadyState(_product));
    return _product;
  }

  Future<Product?> getProductForName(
      String businessId, String productName) async {
    _product =
        await _productRepository.getProductForName(businessId, productName);
    emit(ProductReadyState(_product));
    return _product;
  }

  Future<bool> addProduct(String businessId, Product product) =>
      _productRepository.addProduct(businessId, product);

  Future<bool> updateProduct(Product product) =>
      _productRepository.updateProduct(product);

  Future<bool> deleteProduct(Product product) =>
      _productRepository.deleteProduct(product);

  Stream<List<Product>> getProducts(String businessId) =>
      _productRepository.getProducts(businessId);

  @override
  Future<void> close() {
    return super.close();
  }
}

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductReadyState extends ProductState {
  final Product? product;

  ProductReadyState(this.product);
}
