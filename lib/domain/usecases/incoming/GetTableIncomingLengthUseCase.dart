import '../../../data/repositories/AbstractIncomingRepository.dart';

class GetTableIncomingLengthUseCase {
  final AbstractIncomingRepository incomingRepository;

  GetTableIncomingLengthUseCase({required this.incomingRepository});

  Future<int> get(String businessId) =>
      incomingRepository.getTableIncomingLength(businessId);
}