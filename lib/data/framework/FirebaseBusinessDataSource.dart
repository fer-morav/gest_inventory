import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Business.dart';

class FirebaseBusinessDataSource {
  static const BUSSINESS_COLLECTION = "bussiness";

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Business?> getBusiness(String id) async {
    try {
      final response =
          await _database.collection(BUSSINESS_COLLECTION).doc(id).get();

      if (response.exists && response.data() != null) {
        return Business.fromMap(response.data()!);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<String?> addBussines(Business business) async {
    try {
      final _reference = _database.collection(BUSSINESS_COLLECTION);
      final _businessId = _reference.doc().id;

      business.id = _businessId;

      await _reference.doc(_businessId).set(business.toMap());

      return _businessId;
    } catch (error) {
      return null;
    }
  }
}
