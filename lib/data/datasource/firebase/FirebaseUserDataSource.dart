import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../models/User.dart';
import 'FirebaseConstants.dart';

class FirebaseUserDataSource extends AbstractUserRepository {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  @override
  Future<User?> getUser(String id) async {
    final response = await _database.collection(USERS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return User.fromMap(response.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<bool> addUser(User user) async {
    try {
      await _database
          .collection(USERS_COLLECTION)
          .doc(user.id)
          .set(user.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      await _database
          .collection(USERS_COLLECTION)
          .doc(user.id)
          .update(user.toMap());

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Stream<List<User>> getUsers(String businessId) async* {
    try {
      final snapshots = await _database
          .collection(USERS_COLLECTION)
          .where(User.FIELD_ID_BUSINESS, isEqualTo: businessId)
          .orderBy(User.FIELD_POSITION)
          .snapshots();

      await for (final snapshot in snapshots) {
        final documents = snapshot.docs.where((document) => document.exists);
        final users = documents.map((document) => User.fromMap(document.data())).toList();
        yield users;
      }
    } catch (error) {
      yield [];
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    try {
      await _database.collection(USERS_COLLECTION).doc(id).delete();

      return true;
    } catch (error) {
      return false;
    }
  }
}
