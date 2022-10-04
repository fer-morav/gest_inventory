import '../../../data/repositories/AbstractUserRepository.dart';

class UpdateBusinessIdUseCase {
  final AbstractUserRepository userRepository;

  UpdateBusinessIdUseCase({required this.userRepository});

  Future<bool> update(String id, String businessId) =>
      userRepository.updateBusinessId(id, businessId);
}
