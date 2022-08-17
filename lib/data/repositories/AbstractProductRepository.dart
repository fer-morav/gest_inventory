import '../models/Product.dart';

abstract class AbstractProductRepository {
  Future<Product?> getProduct(String businessId, String productId);
  Future<Product?> getProductForName(String businessId, String productName);
  Future<bool> addProduct(String businessId, Product product);
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(Product product);
  Stream<List<Product>> getProducts(String businessId);
}