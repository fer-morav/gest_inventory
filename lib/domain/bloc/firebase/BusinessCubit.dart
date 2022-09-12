import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/repositories/AbstractBusinessRepository.dart';

class BusinessCubit extends Cubit<void> {
  final AbstractBusinessRepository _businessRepository;

  BusinessCubit(this._businessRepository) : super(0);

  Future<Business?> getBusiness(String id) =>
      _businessRepository.getBusiness(id);

  Future<String?> addBusiness(Business business) =>
      _businessRepository.addBusiness(business);

  Future<bool> updateBusiness(Business business) =>
      _businessRepository.updateBusiness(business);

  Future<bool> deleteBusiness(String id) =>
      _businessRepository.deleteBusiness(id);

  @override
  Future<void> close() {
    return super.close();
  }
}
