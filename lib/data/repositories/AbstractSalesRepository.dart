import '../models/Sales.dart';

abstract class AbstractSalesRepository {
  Future<Sales?> getSale(String businessId, String saleId);
  Future<bool> addSale(Sales sale);
  Future<bool> updateSale(String businessId, String saleId, Map<String, num> changes);
  Future<bool> deleteSale(Sales sale);
  Stream<List<Sales>> getTableSales(String businessId);
  Stream<List<Sales>> getSalesOrder(String businessId, bool order);
  Future<int> getTableSalesLength(String businessId);
}