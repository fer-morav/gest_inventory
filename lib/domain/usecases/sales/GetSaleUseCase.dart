import 'package:gest_inventory/data/repositories/AbstractSalesRepository.dart';
import '../../../data/models/Sales.dart';

class GetSaleUseCase {
  final AbstractSalesRepository salesRepository;

  GetSaleUseCase({required this.salesRepository});

  Future<Sales?> get(String businessId, String saleId) =>
      salesRepository.getSale(businessId, saleId);
}
