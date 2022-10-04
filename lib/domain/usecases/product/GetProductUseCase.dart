import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';
import '../../../data/models/Product.dart';

class GetProductUseCase {
  final AbstractProductRepository productRepository;

  GetProductUseCase({required this.productRepository});

  Future<Product?> get(String businessId, String productId) =>
      productRepository.getProduct(businessId, productId);
}
