import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class GetSalesWeekUseCase {
  final AbstractSalesRepository salesRepository;

  GetSalesWeekUseCase({required this.salesRepository});

  Stream<List<Sales>> get(String productId, {bool descending = false}) =>
      salesRepository.getSalesWeek(productId, descending: descending);
}
