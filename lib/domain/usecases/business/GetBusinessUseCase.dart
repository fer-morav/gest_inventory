import 'package:gest_inventory/data/repositories/AbstractBusinessRepository.dart';
import '../../../data/models/Business.dart';

class GetBusinessUseCase {
  final AbstractBusinessRepository businessRepository;

  GetBusinessUseCase({required this.businessRepository});

  Future<Business?> get(String id) => businessRepository.getBusiness(id);
}