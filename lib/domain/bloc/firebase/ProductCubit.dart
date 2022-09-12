import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';

class ProductCubit extends Cubit<void> {
  final AbstractProductRepository _productRepository;

  ProductCubit(this._productRepository) : super(0);

  Future<Product?> getProduct(String businessId, String productId) =>
      _productRepository.getProduct(businessId, productId);

  Future<Product?> getProductForName(String businessId, String productName) =>
      _productRepository.getProductForName(businessId, productName);

  Future<String?> addProduct(String businessId, Product product) =>
      _productRepository.addProduct(product);

  Future<bool> updateProduct(Product product) =>
      _productRepository.updateProduct(product.id, product.toMap());

  Future<bool> deleteProduct(Product product) =>
      _productRepository.deleteProduct(product);

  Stream<List<Product>> getProducts(String businessId) =>
      _productRepository.getProducts(businessId);

  @override
  Future<void> close() {
    return super.close();
  }
}