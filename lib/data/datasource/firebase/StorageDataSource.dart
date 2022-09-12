import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gest_inventory/data/datasource/firebase/FirebaseConstants.dart';
import 'package:gest_inventory/data/repositories/AbstractStorageRepository.dart';
import 'package:path/path.dart';

class StorageDataSource extends AbstractStorageRepository {
  final _storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadUserPhoto(String userId, File photo) async {
    try {
      final name = basename(photo.path);
      final uploadTask = _storage
          .ref('$PATH_PROFILE_PHOTOS/$userId')
          .child(name)
          .putFile(photo);
      return await (await uploadTask).ref.getDownloadURL();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<String?> uploadBusinessPhoto(String businessId, File photo) async {
    try {
      final name = basename(photo.path);
      final uploadTask = _storage
          .ref('$PATH_BUSINESS_PHOTOS/$businessId')
          .child(name)
          .putFile(photo);
      return await (await uploadTask).ref.getDownloadURL();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<String?> uploadProductPhoto(String productId, File photo) async {
    try {
        final name = basename(photo.path);
        final uploadTask = _storage
            .ref('$PATH_PRODUCTS_PHOTOS/$productId')
            .child(name)
            .putFile(photo);
        return await (await uploadTask).ref.getDownloadURL();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<bool> deletePhoto(String photoUrl) async {
    try {
       await _storage.refFromURL(photoUrl).delete();
      return true;
    } catch (error) {
      return false;
    }
  }
}
