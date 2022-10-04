import 'package:gest_inventory/data/repositories/AbstractSalesRepository.dart';
import '../../../data/models/Sales.dart';

class GetSalesMonthUseCase {
  final AbstractSalesRepository salesRepository;

  GetSalesMonthUseCase({required this.salesRepository});

  Future<List<Sales>> get(String productId, {bool descending = false}) =>
      salesRepository.getSalesMonth(productId, descending: descending);
}
