import '../models/Product.dart';

abstract class AbstractProductRepository {
  Future<String?> addProduct(Product product);
  Future<bool> deleteProduct(Product product);
  Stream<List<Product>> getProducts(String businessId);
  Future<List<Product>> getListProducts(String businessId);
  Future<Product?> getProduct(String businessId, String productId);
  Future<bool> updateProduct(String productId, Map<String, dynamic> changes);
  Future<bool> updateStock(String productId, int quantity, {bool increment = true});
}