import 'dart:io';
import '../../../data/repositories/AbstractStorageRepository.dart';

class UploadProductPhotoUseCase {
  final AbstractStorageRepository storageRepository;

  UploadProductPhotoUseCase({required this.storageRepository});

  Future<String?> upload(String productId, File photo) =>
      storageRepository.uploadProductPhoto(productId, photo);
}