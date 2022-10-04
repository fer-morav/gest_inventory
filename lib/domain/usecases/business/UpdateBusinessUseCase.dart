import '../../../data/models/Business.dart';
import '../../../data/repositories/AbstractBusinessRepository.dart';

class UpdateBusinessUseCase {
  final AbstractBusinessRepository businessRepository;

  UpdateBusinessUseCase({required this.businessRepository});

  Future<bool> update(Business business) =>
      businessRepository.updateBusiness(business);
}
