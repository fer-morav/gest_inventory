import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class UpdateIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  UpdateIncomingUseCase({required this.incomingRepository});

  Future<bool> update(Incomings incoming) =>
      incomingRepository.updateIncoming(incoming);
}