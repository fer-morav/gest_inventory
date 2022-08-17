import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractProductRepository.dart';

import 'FirebaseConstants.dart';

class FirebaseProductDataSource extends AbstractProductRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<bool> addProduct(String businessId, Product product) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(product.idNegocio)
          .collection(BUSINESS_PRODUCT_COLLECTION)
          .doc(product.id)
          .set(product.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(Product product) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(product.idNegocio)
          .collection(BUSINESS_PRODUCT_COLLECTION)
          .doc(product.id)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<Product?> getProduct(String businessId, String productId) async {
    try {
      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_PRODUCT_COLLECTION)
          .doc(productId)
          .get();

      if (response.exists && response.data() != null) {
        return Product.fromMap(response.data()!);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  @override
  Future<Product?> getProductForName(String businessId, String productName) async {
    try {
      if (productName.isEmpty) {
        return null;
      }

      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_PRODUCT_COLLECTION)
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
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_PRODUCT_COLLECTION)
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
  Future<bool> updateProduct(Product product) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(product.idNegocio)
          .collection(BUSINESS_PRODUCT_COLLECTION)
          .doc(product.id)
          .update(product.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }
}