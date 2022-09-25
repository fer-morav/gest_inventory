import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class GetSalesTodayUseCase {
  final AbstractSalesRepository salesRepository;

  GetSalesTodayUseCase({required this.salesRepository});

  Future<List<Sales>> get(String productId, {bool descending = false}) =>
      salesRepository.getSalesToday(productId, descending: descending);
}