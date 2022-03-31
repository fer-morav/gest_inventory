import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Product.dart';

class FirebaseProductDataSouce {
  static const PRODUCTS_COLLECTION = "products";

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Product?> getProduct(String id) async {
    final response = await _database.collection(PRODUCTS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return Product.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _database
          .collection(PRODUCTS_COLLECTION)
          .doc(product.id)
          .set(product.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }
}