import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Business.dart';
import 'package:gest_inventory/data/repositories/AbstractBusinessRepository.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final AbstractBusinessRepository _businessRepository;
  Business? _business;

  BusinessCubit(this._businessRepository) : super(BusinessInitialState());

  Future<void> reset() async => emit(BusinessInitialState());

  Future<Business?> getBusiness(String id) async {
    _business = await _businessRepository.getBusiness(id);
    emit(BusinessReadyState(_business));
    return _business;
  }

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

abstract class BusinessState {}

class BusinessInitialState extends BusinessState {}

class BusinessReadyState extends BusinessState {
  final Business? business;

  BusinessReadyState(this.business);
}
