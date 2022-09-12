import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class AddProductUseCase {
  final AbstractProductRepository productRepository;

  AddProductUseCase({required this.productRepository});

  Future<String?> add(Product product) =>
      productRepository.addProduct(product);
}
