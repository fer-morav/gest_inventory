import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class UpdateIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  UpdateIncomingUseCase({required this.incomingRepository});

  Future<bool> update(String productId, Incoming incoming) =>
      incomingRepository.updateIncoming(productId, incoming);
}