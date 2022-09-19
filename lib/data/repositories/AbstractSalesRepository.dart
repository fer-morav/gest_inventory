import '../models/Sales.dart';

abstract class AbstractSalesRepository {
  Future<Sales?> getSale(String productId, String saleId);
  Future<bool> addSale(String productId, Sales sale);
  Future<bool> deleteSale(String productId, Sales sale);
  Stream<List<Sales>> getSales(String productId, {bool descending = false});
  Stream<List<Sales>> getSalesToday(String productId, {bool descending = false});
  Stream<List<Sales>> getSalesWeek(String productId, {bool descending = false});
  Stream<List<Sales>> getSalesMonth(String productId, {bool descending = false});
}