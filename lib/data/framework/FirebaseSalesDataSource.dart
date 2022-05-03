import '../models/Sales.dart';
import 'FirebaseConstants.dart';

class FirebaseSalesDataSource {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Sales?> getSale(String businessId, String saleId) async {
    try {
      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .doc(saleId)
          .get();

      if (response.exists && response.data() != null) {
        return Sales.fromMap(response.data()!);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> addSale(Sales sale) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(sale.idNegocio)
          .collection(BUSINESS_SALES_COLLECTION)
          .doc(sale.id)
          .set(sale.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateSale(
      String businessId, String saleId, Map<String, num> changes) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .doc(saleId)
          .update(changes);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteSale(Sales sale) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(sale.idNegocio)
          .collection(BUSINESS_SALES_COLLECTION)
          .doc(sale.id)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Sales>> getTableSales(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .get();

      List<Sales> sales = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());
        sales.add(sale);
      }

      return sales;
    } catch (error) {
      return [];
    }
  }

  Future<List<Sales>> getSalesOrder(String businessId, bool Order) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .get();

      List<Sales> temps = [];
      List<Sales> sales = [];
      List<int> solds = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());
        solds.add(sale.ventasUnitario + sale.ventasMayoreo);
        temps.add(sale);
      }

      solds.sort();

      for (var sold in solds) {
        for (var temp in temps) {
          if ((temp.ventasMayoreo + temp.ventasUnitario) == sold &&
              !sales.contains(temp)) {
            sales.add(temp);
          }
        }
      }

      if(Order) {
        sales = List.from(sales.reversed);
      }
      return sales;
    } catch (error) {
      return [];
    }
  }

  Future<int> getTableSalesLength(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .get();

      List<Sales> sales = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());
        sales.add(sale);
      }

      return sales.length;
    } catch (error) {
      return 0;
    }
  }
}