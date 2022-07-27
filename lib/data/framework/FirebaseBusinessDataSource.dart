import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../models/Business.dart';
import '../models/Product.dart';
import 'FirebaseConstants.dart';

class FirebaseBusinessDataSource {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Business?> getBusiness(String id) async {
    final response =
        await _database.collection(BUSINESS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return Business.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  Future<String?> addBusiness(Business business) async {
    try {
      final reference = _database.collection(BUSINESS_COLLECTION);
      final businessId = reference.doc().id;

      business.id = businessId;

      await reference.doc(businessId).set(business.toMap());

      return businessId;
    } catch (error) {
      return null;
    }
  }

  Future<bool> updateBusiness(Business business) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(business.id)
          .update(business.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteBusiness(String id) async {
    try {
      await _database.collection(BUSINESS_COLLECTION).doc(id).delete();

      return true;
    } catch (error) {
      return false;
    }
  }

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

  Future<Product?> getProductForName(
      String businessId, String productName) async {
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

  Future<List<Product>> getProducts(String businessId) async {
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

      return products;
    } catch (error) {
      return [];
    }
  }
}
