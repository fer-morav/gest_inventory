import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';

class GetIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetIncomingUseCase({required this.incomingRepository});

  Future<Incoming?> get(String productId, String incomingId) =>
      incomingRepository.getIncoming(productId, incomingId);
}
