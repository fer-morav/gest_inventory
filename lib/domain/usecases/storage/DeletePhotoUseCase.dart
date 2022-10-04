import '../../../data/repositories/AbstractStorageRepository.dart';

class DeletePhotoUseCase {
  final AbstractStorageRepository storageRepository;

  DeletePhotoUseCase({required this.storageRepository});

  Future<bool> delete(String photoUrl) =>
      storageRepository.deletePhoto(photoUrl);
}