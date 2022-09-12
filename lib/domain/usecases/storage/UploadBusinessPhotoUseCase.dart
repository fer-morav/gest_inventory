import 'dart:io';
import '../../../data/repositories/AbstractStorageRepository.dart';

class UploadBusinessPhotoUseCase {
  final AbstractStorageRepository storageRepository;

  UploadBusinessPhotoUseCase({required this.storageRepository});

  Future<String?> upload(String businessId, File photo) =>
      storageRepository.uploadBusinessPhoto(businessId, photo);
}
