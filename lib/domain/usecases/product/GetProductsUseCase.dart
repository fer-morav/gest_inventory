import '../../../data/models/Product.dart';
import '../../../data/repositories/AbstractProductRepository.dart';

class GetProductsUseCase {
  final AbstractProductRepository productRepository;

  GetProductsUseCase({required this.productRepository});

  Stream<List<Product>> getProducts(String businessId) => productRepository.getProducts(businessId);

  Future<List<Product>> getList(String businessId) => productRepository.getListProducts(businessId);
}