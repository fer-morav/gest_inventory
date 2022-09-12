import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';

class GetIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetIncomingUseCase({required this.incomingRepository});

  Future<Incomings?> get(String businessId, String incomingId) =>
      incomingRepository.getIncoming(businessId, incomingId);
}
