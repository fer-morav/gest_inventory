import '../../../data/repositories/AbstractUserRepository.dart';

class UpdateUserMapUseCase {
  final AbstractUserRepository userRepository;

  UpdateUserMapUseCase({required this.userRepository});

  Future<bool> update(String id, Map<String, dynamic> map) =>
      userRepository.updateUserMap(id, map);
}
