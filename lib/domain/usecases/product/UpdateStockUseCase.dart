import '../../../data/repositories/AbstractProductRepository.dart';

class UpdateProductStockUseCase {
  final AbstractProductRepository productRepository;

  UpdateProductStockUseCase({required this.productRepository});

  Future<bool> update(String productId, int quantity, {bool increment = true}) =>
      productRepository.updateStock(productId, quantity, increment: increment);
}
