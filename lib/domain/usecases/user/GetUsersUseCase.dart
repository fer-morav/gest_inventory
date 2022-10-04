import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import '../../../data/models/User.dart';

class GetUsersUseCase {
  final AbstractUserRepository userRepository;
  
  GetUsersUseCase({required this.userRepository});

  Stream<List<User>> getUsers(String businessId,
          {String userExcludedId = ''}) =>
      userRepository.getUsers(businessId, userExcludedId: userExcludedId);

  Future<List<User>> getList(String businessId, {String userExcludedId = ''}) =>
      userRepository.getListUsers(businessId, userExcludedId: userExcludedId);
}