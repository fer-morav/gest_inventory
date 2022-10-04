import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/repositories/AbstractSalesRepository.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../models/Sales.dart';
import 'FirebaseConstants.dart';

class SalesDataSource extends AbstractSalesRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<bool> addSale(String productId, Sales sale) async {
    try {
      final reference = _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION);

      final salesId = reference.doc().id;

      sale.id = salesId;

      await reference.doc(salesId).set(sale.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> deleteSale(String productId, Sales sale) async {
    try {
      await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION)
          .doc(sale.id)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<Sales?> getSale(String productId, String saleId) async {
    final response = await _database
        .collection(PRODUCT_COLLECTION)
        .doc(productId)
        .collection(SALES_COLLECTION)
        .doc(saleId)
        .get();

    if (response.exists && response.data() != null) {
      return Sales.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<Sales>> getSales(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION)
          .orderBy(Sales.FIELD_CREATION_DATE, descending: descending)
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

  @override
  Future<List<Sales>> getSalesMonth(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION)
          .orderBy(Sales.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Sales> sales = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());

        if (sale.creationDate.toDate().inMonth()) {
          sales.add(sale);
        }
      }
      return sales;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Sales>> getSalesToday(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION)
          .orderBy(Sales.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Sales> sales = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());

        if (sale.creationDate.toDate().isToday()) {
          sales.add(sale);
        }
      }
      return sales;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Sales>> getSalesWeek(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(SALES_COLLECTION)
          .orderBy(Sales.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Sales> sales = [];

      for (var document in snapshots.docs) {
        final sale = Sales.fromMap(document.data());

        if (sale.creationDate.toDate().inWeek()) {
          sales.add(sale);
        }
      }
      return sales;
    } catch (error) {
      return [];
    }
  }
}
