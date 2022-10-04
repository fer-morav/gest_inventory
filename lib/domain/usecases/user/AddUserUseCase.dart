import '../../../data/models/User.dart';
import '../../../data/repositories/AbstractUserRepository.dart';

class AddUserUseCase {
  final AbstractUserRepository userRepository;

  AddUserUseCase({required this.userRepository});

  Future<bool> add(User user) => userRepository.addUser(user);
}