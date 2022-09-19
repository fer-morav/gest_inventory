import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class GetUsersUseCase {
  final AbstractUserRepository userRepository;
  
  GetUsersUseCase({required this.userRepository});

  Stream<List<User>> getUsers(String businessId) => userRepository.getUsers(businessId);

  Future<List<User>> getList(String businessId) => userRepository.getListUsers(businessId);
}