import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class DeleteProductUseCase {
  final AbstractProductRepository productRepository;

  DeleteProductUseCase({required this.productRepository});

  Future<bool> delete(Product product) => productRepository.deleteProduct(product);
}