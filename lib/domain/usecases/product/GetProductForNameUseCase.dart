import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class GetProductForNameUseCase {
  final AbstractProductRepository productRepository;

  GetProductForNameUseCase({required this.productRepository});

  Future<Product?> get(String businessId, String productName) =>
      productRepository.getProductForName(businessId, productName);
}
