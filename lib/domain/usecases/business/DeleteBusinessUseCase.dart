import '../../../data/repositories/AbstractBusinessRepository.dart';

class DeleteBusinessUseCase {
  final AbstractBusinessRepository businessRepository;

  DeleteBusinessUseCase({required this.businessRepository});

  Future<bool> delete(String id) => businessRepository.deleteBusiness(id);
}
