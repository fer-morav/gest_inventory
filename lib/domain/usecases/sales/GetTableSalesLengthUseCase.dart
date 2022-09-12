import '../../../data/repositories/AbstractSalesRepository.dart';

class GetTableSalesLengthUseCase {
  final AbstractSalesRepository salesRepository;

  GetTableSalesLengthUseCase({required this.salesRepository});

  Future<int> getTableSalesLength(String businessId) =>
      salesRepository.getTableSalesLength(businessId);
}