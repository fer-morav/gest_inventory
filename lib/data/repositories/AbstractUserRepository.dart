import '../models/User.dart';

abstract class AbstractUserRepository {
  Future<User?> getUser(String id);
  Future<bool> addUser(User user);
  Future<bool> updateUser(User user);
  Stream<List<User>> getUsers(String businessId);
  Future<bool> deleteUser(String id);
}