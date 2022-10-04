import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class DeleteSaleUseCase {
  final AbstractSalesRepository salesRepository;

  DeleteSaleUseCase({required this.salesRepository});

  Future<bool> delete(String productId, Sales sale) => salesRepository.deleteSale(productId, sale);
}