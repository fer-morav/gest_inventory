import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class GetUsersUseCase {
  final AbstractUserRepository userRepository;
  
  GetUsersUseCase({required this.userRepository});

  Stream<List<User>> get(String businessId) => userRepository.getUsers(businessId);
}