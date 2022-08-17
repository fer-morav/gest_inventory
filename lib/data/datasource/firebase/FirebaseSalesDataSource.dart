import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/repositories/AbstractSalesRepository.dart';
import '../../models/Sales.dart';
import 'FirebaseConstants.dart';

class FirebaseSalesDataSource extends AbstractSalesRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
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

  @override
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

  @override
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

  @override
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

  @override
  Stream<List<Sales>> getTableSales(String businessId) async* {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .orderBy(Sales.TOTAL, descending: true)
          .snapshots();

      await for (var document in snapshots) {
        final documents = document.docs.where((element) => element.exists);
        final sales = documents
            .map((document) => Sales.fromMap(document.data()))
            .toList();
        yield sales;
      }
    } catch (error) {
      yield [];
    }
  }

  @override
  Stream<List<Sales>> getSalesOrder(String businessId, bool order) async* {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_SALES_COLLECTION)
          .orderBy(Sales.VENTAS_MAYOREO, descending: order)
          .orderBy(Sales.VENTAS_UNITARIO, descending: order)
          .orderBy(Sales.TOTAL, descending: order)
          .snapshots();

      await for (final snapshot in snapshots) {
        final documents = snapshot.docs.where((document) => document.exists);
        final sales = documents
            .map((document) => Sales.fromMap(document.data()))
            .toList();
        yield sales;
      }
    } catch (error) {
      yield [];
    }
  }

  @override
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
