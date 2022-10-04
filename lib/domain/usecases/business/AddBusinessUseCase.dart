import '../../../data/models/Business.dart';
import '../../../data/repositories/AbstractBusinessRepository.dart';

class AddBusinessUseCase {
  final AbstractBusinessRepository businessRepository;

  AddBusinessUseCase({required this.businessRepository});

  Future<String?> add(Business business) =>
      businessRepository.addBusiness(business);
}
