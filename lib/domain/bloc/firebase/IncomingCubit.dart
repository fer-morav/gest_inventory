import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/Incoming.dart';
import '../../../data/repositories/AbstractIncomingRepository.dart';

class IncomingCubit extends Cubit<IncomingState> {
  final AbstractIncomingRepository _incomingRepository;
  Incomings? _incoming;

  IncomingCubit(this._incomingRepository) : super(IncomingInitialState());

  Future<void> reset() async => emit(IncomingInitialState());

  Future<Incomings?> getIncoming(String businessId, String incomingId) async {
    _incoming = await _incomingRepository.getIncoming(businessId, incomingId);
    emit(IncomingReadyState(_incoming));
    return _incoming;
  }

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

abstract class IncomingState {}

class IncomingInitialState extends IncomingState {}

class IncomingReadyState extends IncomingState {
  final Incomings? incoming;

  IncomingReadyState(this.incoming);
}
