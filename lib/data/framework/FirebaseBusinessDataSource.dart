import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/framework/FirebaseUserDataSource.dart';
import 'package:gest_inventory/data/models/User.dart';

import '../models/Business.dart';
import '../models/Product.dart';

class FirebaseBusinessDataSource {
  static const BUSINESS_COLLECTION = "business";
  static const BUSINESS_PRODUCT_COLLECTION = "products";
  static const USERS_COLLECTION = "users";

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Business?> getBusiness(String id) async {
    final response = await _database.collection(BUSINESS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return Business.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  Future<String?> addBusiness(Business business) async {
    try {
      final _reference = _database.collection(BUSINESS_COLLECTION);
      final _businessId = _reference.doc().id;

      business.id = _businessId;

      await _reference.doc(_businessId).set(business.toMap());

      return _businessId;
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

  Future<List<User>> getEmployees(String businessId) async {
    try {
      final snapshots = await _database.collection(USERS_COLLECTION).get();

      List<User> users = [];

      for (var document in snapshots.docs) {
        final user = User.fromMap(document.data());
        if(user.idNegocio == businessId){
          users.add(user);
        }
      }

      return users;
    } catch (error) {
      return [];
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

  Future<Product?> getProductForName(String businessId, String productName) async {
    try {
      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_PRODUCT_COLLECTION)
          .get();

      if(productName.isEmpty) {
        return null;
      }

      Product? product;

      for(var document in response.docs) {
        final temp = Product.fromMap(document.data());
        if(temp.nombre.contains(productName)){
          product = temp;
        }
      }
      return product;
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
