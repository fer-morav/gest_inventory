import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class DeleteSaleUseCase {
  final AbstractSalesRepository salesRepository;

  DeleteSaleUseCase({required this.salesRepository});

  Future<bool> delete(Sales sale) => salesRepository.deleteSale(sale);
}