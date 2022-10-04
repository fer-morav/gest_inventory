import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';

class GetListIncomingWeekUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetListIncomingWeekUseCase({required this.incomingRepository});

  Future<List<Incoming>> get(String productId, {bool descending = false}) =>
      incomingRepository.getListIncomingWeek(productId, descending: descending);
}