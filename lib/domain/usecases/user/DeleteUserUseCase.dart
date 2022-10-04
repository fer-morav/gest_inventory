import '../../../data/repositories/AbstractUserRepository.dart';

class DeleteUserUseCase {
  final AbstractUserRepository userRepository;

  DeleteUserUseCase({required this.userRepository});

  Future<bool> deleteUser(String id) => userRepository.deleteUser(id);
}