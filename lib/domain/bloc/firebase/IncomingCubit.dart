import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class IncomingCubit extends Cubit<void> {
  final AbstractIncomingRepository _incomingRepository;

  IncomingCubit(this._incomingRepository) : super(0);

  Future<Incomings?> getIncoming(String businessId, String incomingId) =>
      _incomingRepository.getIncoming(businessId, incomingId);

  Future<bool> addIncoming(Incomings incoming) =>
      _incomingRepository.addIncoming(incoming);

  Future<bool> updateIncoming(Incomings incoming) =>
      _incomingRepository.updateIncoming(incoming);

  Future<bool> deleteIncoming(Incomings incoming) =>
      _incomingRepository.deleteIncoming(incoming);

  Future<List<Incomings>> getTableIncoming(String businessId) =>
      _incomingRepository.getTableIncoming(businessId);

  Future<int> getTableIncomingLength(String businessId) =>
      _incomingRepository.getTableIncomingLength(businessId);

  @override
  Future<void> close() {
    return super.close();
  }
}
