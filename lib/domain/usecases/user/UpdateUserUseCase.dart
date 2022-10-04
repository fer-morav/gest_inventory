import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class UpdateUserUseCase {
  final AbstractUserRepository userRepository;

  UpdateUserUseCase({required this.userRepository});

  Future<bool> update(User user) => userRepository.updateUser(user);
}