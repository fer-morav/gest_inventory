import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Bussiness.dart';

class FirebaseBussinessDataSouce {
  static const BUSSINESS_COLLECTION = "bussiness";

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Bussiness?> getBussiness(String id) async {
    final response = await _database.collection(BUSSINESS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return Bussiness.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  Future<bool> addBussines(Bussiness bussiness) async {
    try {
      await _database
          .collection(BUSSINESS_COLLECTION)
          .doc(bussiness.id)
          .set(bussiness.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }
}