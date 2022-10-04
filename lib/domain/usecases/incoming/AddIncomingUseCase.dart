import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class AddIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  AddIncomingUseCase({required this.incomingRepository});

  Future<bool> add(String productId, Incoming incoming) =>
      incomingRepository.addIncoming(productId, incoming);
}