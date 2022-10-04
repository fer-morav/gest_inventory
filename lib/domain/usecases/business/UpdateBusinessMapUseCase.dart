import '../../../data/repositories/AbstractBusinessRepository.dart';

class UpdateBusinessMapUseCase {
  final AbstractBusinessRepository businessRepository;

  UpdateBusinessMapUseCase({required this.businessRepository});

  Future<bool> update(String id, Map<String, dynamic> map) =>
      businessRepository.updateBusinessMap(id, map);
}