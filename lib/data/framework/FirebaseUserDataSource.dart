import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';

class FirebaseUserDataSouce {
  static const USERS_COLLECTION = "users";

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Future<User?> getUser(String id) async {
    final response = await _database.collection(USERS_COLLECTION).doc(id).get();

    if (response.exists && response.data() != null) {
      return User.fromMap(response.data()!);
    } else {
      return null;
    }
  }

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
}