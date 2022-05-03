import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/Incomings.dart';
import 'FirebaseConstants.dart';

class FirebaseIncomingsDataSource {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<Incomings?> getIncoming(String businessId, String incomingsId) async {
    try {
      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .doc(incomingsId)
          .get();

      if (response.exists && response.data() != null) {
        return Incomings.fromMap(response.data()!);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> addIncoming(Incomings incomming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incomming.idNegocio)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .doc(incomming.id)
          .set(incomming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateIncoming(Incomings incoming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incoming.idNegocio)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .doc(incoming.id)
          .update(incoming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteIncoming(Incomings incoming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incoming.idNegocio)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .doc(incoming.id)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<Incomings>> getTableIncomings(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .get();

      List<Incomings> incomings = [];

      for (var document in snapshots.docs) {
        final incomig = Incomings.fromMap(document.data());
        incomings.add(incomig);
      }

      return incomings;
    } catch (error) {
      return [];
    }
  }

  Future<int> getTableIncomingsLength(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMINGS_COLLECTION)
          .get();

      List<Incomings> incomings = [];

      for (var document in snapshots.docs) {
        final incomig = Incomings.fromMap(document.data());
        incomings.add(incomig);
      }

      return incomings.length;
    } catch (error) {
      return 0;
    }
  }

}