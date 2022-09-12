import '../models/Product.dart';

abstract class AbstractProductRepository {
  Future<String?> addProduct(Product product);
  Future<bool> deleteProduct(Product product);
  Future<Product?> getProductForName(String businessId, String productName);
  Stream<List<Product>> getProducts(String businessId);
  Future<Product?> getProduct(String businessId, String productId);
  Future<bool> updateProduct(String productId, Map<String, dynamic> changes);
}