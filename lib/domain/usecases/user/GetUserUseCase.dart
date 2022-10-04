import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class GetUserUseCase {
  final AbstractUserRepository userRepository;

  GetUserUseCase({required this.userRepository});

  Future<User?> get(String id) => userRepository.getUser(id);
}