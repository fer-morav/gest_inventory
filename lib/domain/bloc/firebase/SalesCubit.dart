import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';

class SalesCubit extends Cubit<void> {
  final AbstractSalesRepository _salesRepository;

  SalesCubit(this._salesRepository) : super(0);

  Future<Sales?> getSale(String businessId, String saleId) =>
      _salesRepository.getSale(businessId, saleId);

  Future<bool> addSale(Sales sale) => _salesRepository.addSale(sale);

  Future<bool> updateSale(
          String businessId, String saleId, Map<String, num> changes) =>
      _salesRepository.updateSale(businessId, saleId, changes);

  Future<bool> deleteSale(Sales sale) => _salesRepository.deleteSale(sale);

  Stream<List<Sales>> getTableSales(String businessId) =>
      _salesRepository.getTableSales(businessId);

  Stream<List<Sales>> getSalesOrder(String businessId, bool order) =>
      _salesRepository.getSalesOrder(businessId, order);

  Future<int> getTableSalesLength(String businessId) =>
      _salesRepository.getTableSalesLength(businessId);

  @override
  Future<void> close() {
    return super.close();
  }
}
