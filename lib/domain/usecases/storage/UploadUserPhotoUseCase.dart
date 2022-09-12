import 'dart:io';
import 'package:gest_inventory/data/repositories/AbstractStorageRepository.dart';

class UploadUserPhotoUseCase {
  final AbstractStorageRepository storageRepository;

  UploadUserPhotoUseCase({required this.storageRepository});

  Future<String?> uploadPhoto(String userId, File photo) =>
      storageRepository.uploadUserPhoto(userId, photo);
}
