import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';

class GetListIncomingTodayUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetListIncomingTodayUseCase({required this.incomingRepository});

  Future<List<Incoming>> get(String productId, {bool descending = false}) =>
      incomingRepository.getListIncomingToday(productId, descending: descending);
}