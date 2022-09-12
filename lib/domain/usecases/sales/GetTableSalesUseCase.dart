import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class GetTableSalesUseCase {
  final AbstractSalesRepository salesRepository;

  GetTableSalesUseCase({required this.salesRepository});

  Stream<List<Sales>> get(String businessId) =>
      salesRepository.getTableSales(businessId);
}
