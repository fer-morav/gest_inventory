import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import '../../../data/models/Incoming.dart';

class GetListIncomingMonthUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetListIncomingMonthUseCase({required this.incomingRepository});

  Future<List<Incoming>> get(String productId, {bool descending = false}) =>
      incomingRepository.getListIncomingMonth(productId, descending: descending);
}