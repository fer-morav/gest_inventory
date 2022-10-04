import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class GetUsersAvailableUseCase {
  final AbstractUserRepository userRepository;

  GetUsersAvailableUseCase({required this.userRepository});

  Stream<List<User>> get() => userRepository.getUsersAvailable();
}