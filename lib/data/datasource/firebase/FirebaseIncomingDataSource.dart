import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'FirebaseConstants.dart';

class FirebaseIncomingDataSource extends AbstractIncomingRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<Incomings?> getIncoming(String businessId, String incomingId) async {
    try {
      final response = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .doc(incomingId)
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

  @override
  Future<bool> addIncoming(Incomings incoming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incoming.idNegocio)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .doc(incoming.id)
          .set(incoming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> updateIncoming(Incomings incoming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incoming.idNegocio)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .doc(incoming.id)
          .update(incoming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> deleteIncoming(Incomings incoming) async {
    try {
      await _database
          .collection(BUSINESS_COLLECTION)
          .doc(incoming.idNegocio)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .doc(incoming.id)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<List<Incomings>> getTableIncoming(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .get();

      List<Incomings> incoming = [];

      for (var document in snapshots.docs) {
        final inco = Incomings.fromMap(document.data());
        incoming.add(inco);
      }

      return incoming;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<int> getTableIncomingLength(String businessId) async {
    try {
      final snapshots = await _database
          .collection(BUSINESS_COLLECTION)
          .doc(businessId)
          .collection(BUSINESS_INCOMING_COLLECTION)
          .get();

      List<Incomings> incoming = [];

      for (var document in snapshots.docs) {
        final incom = Incomings.fromMap(document.data());
        incoming.add(incom);
      }

      return incoming.length;
    } catch (error) {
      return 0;
    }
  }
}