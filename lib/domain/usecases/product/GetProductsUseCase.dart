import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class GetProductsUseCase {
  final AbstractProductRepository productRepository;

  GetProductsUseCase({required this.productRepository});

  Stream<List<Product>> get(String businessId) =>
      productRepository.getProducts(businessId);
}