import 'dart:io';

abstract class AbstractStorageRepository {
  Future<String?> uploadUserPhoto(String userId, File photo);
  Future<String?> uploadBusinessPhoto(String businessId, File photo);
  Future<String?> uploadProductPhoto(String productId, File photo);
  Future<bool> deletePhoto(String photoUrl);
}