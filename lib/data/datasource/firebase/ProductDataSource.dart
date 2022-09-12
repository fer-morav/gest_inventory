import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';
import 'FirebaseConstants.dart';

class ProductDataSource extends AbstractProductRepository {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<String?> addProduct(Product product) async {
    try {
      final reference = _database.collection(PRODUCT_COLLECTION);
      final productId = reference.doc().id;

      product.id = productId;

      await reference.doc(productId).set(product.toMap());

      return productId;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<bool> deleteProduct(Product product) async {
    try {
      await _database.collection(PRODUCT_COLLECTION).doc(product.id).delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<Product?> getProduct(String businessId, String productBarcode) async {
    try {
      final response = await _database
          .collection(PRODUCT_COLLECTION)
          .where(Product.FIELD_BUSINESS_ID, isEqualTo: businessId)
          .where(Product.FIELD_BARCODE, isEqualTo: productBarcode)
          .limit(1)
          .get();

      final products = response.docs
          .where((product) => product.exists)
          .map((e) => Product.fromMap(e.data()))
          .toList();

      return products.first;
    } catch (error) {
      return null;
    }
  }

  @override
  Future<Product?> getProductForName(String businessId, String productName) async {
    try {
      final response = await _database
          .collection(PRODUCT_COLLECTION)
          .where(Product.FIELD_BUSINESS_ID, isEqualTo: businessId)
          .where(Product.FIELD_NAME, isEqualTo: productName)
          .limit(1)
          .get();

      final products = response.docs
          .where((element) => element.exists)
          .map((e) => Product.fromMap(e.data()))
          .toList();

      return products.first;
    } catch (error) {
      return null;
    }
  }

  @override
  Stream<List<Product>> getProducts(String businessId) async* {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .where(Product.FIELD_BUSINESS_ID, isEqualTo: businessId)
          .orderBy(Product.FIELD_NAME)
          .get();

      List<Product> products = [];

      for (var document in snapshots.docs) {
        final product = Product.fromMap(document.data());
        products.add(product);
      }

      yield products;
    } catch (error) {
      yield [];
    }
  }

  @override
  Future<bool> updateProduct(String productId, Map<String, dynamic> changes) async {
    try {
      await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .update(changes);

      return true;
    } catch (error) {
      return false;
    }
  }
}