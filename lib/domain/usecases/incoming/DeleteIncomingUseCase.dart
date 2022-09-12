import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class DeleteIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  DeleteIncomingUseCase({required this.incomingRepository});

  Future<bool> delete(Incomings incoming) =>
      incomingRepository.deleteIncoming(incoming);
}