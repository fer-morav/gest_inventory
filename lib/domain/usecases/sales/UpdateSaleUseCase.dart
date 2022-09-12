import '../../../data/repositories/AbstractSalesRepository.dart';

class UpdateSaleUseCase {
  final AbstractSalesRepository salesRepository;

  UpdateSaleUseCase({required this.salesRepository});

  Future<bool> update(
    String businessId,
    String saleId,
    Map<String, num> changes,
  ) => salesRepository.updateSale(businessId, saleId, changes);
}
