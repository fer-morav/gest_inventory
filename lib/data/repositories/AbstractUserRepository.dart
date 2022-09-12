import '../models/User.dart';

abstract class AbstractUserRepository {
  Future<User?> getUser(String id);
  Future<bool> addUser(User user);
  Future<bool> updateUser(User user);
  Future<bool> updateUserMap(String id, Map<String, dynamic> map);
  Future<bool> updateBusinessId(String id, String businessId);
  Stream<List<User>> getUsers(String businessId);
  Future<bool> deleteUser(String id);
  Stream<String?> listenBusinessId(String id);
  Stream<List<User>> getUsersAvailable();
}