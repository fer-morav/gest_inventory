import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';
class GetListIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetListIncomingUseCase({required this.incomingRepository});

  Future<List<Incoming>> get(String productId, {bool descending = false}) =>
      incomingRepository.getListIncoming(productId, descending: descending);
}