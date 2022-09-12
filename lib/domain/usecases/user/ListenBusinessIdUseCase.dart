import '../../../data/repositories/AbstractUserRepository.dart';

class ListenBusinessIdUseCase {
  final AbstractUserRepository userRepository;

  ListenBusinessIdUseCase({required this.userRepository});

  Stream<String?> listen(String id) => userRepository.listenBusinessId(id);
}