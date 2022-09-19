import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class GetSalesUseCase {
  final AbstractSalesRepository salesRepository;

  GetSalesUseCase({required this.salesRepository});

  Stream<List<Sales>> get(String productId, {bool descending = false}) =>
      salesRepository.getSales(productId, descending: descending);
}