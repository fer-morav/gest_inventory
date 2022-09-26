import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import 'FirebaseConstants.dart';

class IncomingDataSource extends AbstractIncomingRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<bool> addIncoming(String productId, Incoming incoming) async {
    try {
      final reference = _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION);

      final incomingId = reference.doc().id;

      incoming.id = incomingId;

      await reference.doc(incomingId).set(incoming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> deleteIncoming(String productId, String incomingId) async {
    try {
      await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .doc(incomingId)
          .delete();

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<Incoming?> getIncoming(String productId, String incomingId) async {
    final response = await _database
        .collection(PRODUCT_COLLECTION)
        .doc(productId)
        .collection(INCOMING_COLLECTION)
        .doc(incomingId)
        .get();

    if (response.exists && response.data() != null) {
      return Incoming.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<Incoming>> getListIncoming(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .orderBy(Incoming.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Incoming> listIncoming = [];

      for (var document in snapshots.docs) {
        final incoming = Incoming.fromMap(document.data());
        listIncoming.add(incoming);
      }
      return listIncoming;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Incoming>> getListIncomingMonth(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .orderBy(Incoming.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Incoming> listIncoming = [];

      for (var document in snapshots.docs) {
        final incoming = Incoming.fromMap(document.data());

        if (incoming.creationDate.toDate().inMonth()) {
          listIncoming.add(incoming);
        }
      }
      return listIncoming;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Incoming>> getListIncomingToday(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .orderBy(Incoming.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Incoming> listIncoming = [];

      for (var document in snapshots.docs) {
        final incoming = Incoming.fromMap(document.data());

        if (incoming.creationDate.toDate().isToday()) {
          listIncoming.add(incoming);
        }
      }
      return listIncoming;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<List<Incoming>> getListIncomingWeek(String productId, {bool descending = false}) async {
    try {
      final snapshots = await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .orderBy(Incoming.FIELD_CREATION_DATE, descending: descending)
          .get();

      List<Incoming> listIncoming = [];

      for (var document in snapshots.docs) {
        final incoming = Incoming.fromMap(document.data());

        if (incoming.creationDate.toDate().inWeek()) {
          listIncoming.add(incoming);
        }
      }
      return listIncoming;
    } catch (error) {
      return [];
    }
  }

  @override
  Future<bool> updateIncoming(String productId, Incoming incoming) async {
    try {
      await _database
          .collection(PRODUCT_COLLECTION)
          .doc(productId)
          .collection(INCOMING_COLLECTION)
          .doc(incoming.id)
          .update(incoming.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }
}