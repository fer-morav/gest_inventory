import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/repositories/AbstractBusinessRepository.dart';
import '../../models/Business.dart';
import 'FirebaseConstants.dart';

class BusinessDataSource extends AbstractBusinessRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<Business?> getBusiness(String id) async {
    final response =
        await _database.collection(BUSINESS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return Business.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  @override
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

  @override
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

  @override
  Future<bool> deleteBusiness(String id) async {
    try {
      await _database.collection(BUSINESS_COLLECTION).doc(id).delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> updateBusinessMap(String id, Map<String, dynamic> map) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(id)
          .update(map);

      return true;
    } catch (error) {
      return false;
    }
  }
}
