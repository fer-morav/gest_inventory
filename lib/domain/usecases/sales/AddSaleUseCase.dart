import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class AddSaleUseCase {
  final AbstractSalesRepository salesRepository;

  AddSaleUseCase({required this.salesRepository});

  Future<bool> add(String productId, Sales sale) => salesRepository.addSale(productId, sale);
}
