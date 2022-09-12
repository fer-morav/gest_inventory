import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class GetSalesOrder {
  final AbstractSalesRepository salesRepository;

  GetSalesOrder({required this.salesRepository});

  Stream<List<Sales>> get(String businessId, bool order) =>
      salesRepository.getSalesOrder(businessId, order);
}