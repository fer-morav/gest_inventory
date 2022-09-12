import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class GetTableIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetTableIncomingUseCase({required this.incomingRepository});

  Future<List<Incomings>> get(String businessId) =>
      incomingRepository.getTableIncoming(businessId);
}