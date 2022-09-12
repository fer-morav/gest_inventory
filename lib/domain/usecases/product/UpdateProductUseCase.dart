import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class UpdateProductUseCase {
  final AbstractProductRepository productRepository;

  UpdateProductUseCase({required this.productRepository});

  Future<bool> update(String productId, Map<String, dynamic> changes) =>
      productRepository.updateProduct(productId, changes);
}
