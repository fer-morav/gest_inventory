import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/domain/usecases/user/UpdateUserMapUseCase.dart';
import 'package:gest_inventory/utils/arguments.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractUserRepository.dart';
import '../usecases/user/ListenBusinessIdUseCase.dart';

class WaitingCubit extends Cubit<WaitingState> {
  final AbstractUserRepository userRepository;

  late ListenBusinessIdUseCase _listenBusinessIdUseCase;
  late UpdateUserMapUseCase _updateUserMapUseCase;
  late StreamSubscription _streamSubscription;

  WaitingCubit(this.userRepository) : super(WaitingState()) {}

  void init(Map<dynamic, dynamic> args) async {
    User? user = args[user_args];

    emit(WaitingState(user: user));

    _listenBusinessIdUseCase =
        ListenBusinessIdUseCase(userRepository: userRepository);
    _updateUserMapUseCase =
        UpdateUserMapUseCase(userRepository: userRepository);

    if (!await updateStatus(true)) {
      emit(WaitingState(user: null));
    }

    if (state.user != null) {
      _streamSubscription = _listenBusinessIdUseCase
          .listen(state.user!.id)
          .listen((event) => _stateChange(event));
    }
  }

  void reset() => emit(WaitingState(user: null));

  void _stateChange(String? id) => _nextState(businessId: id);

  Future<bool> updateStatus(bool status) async {
    if (state.user != null) {
      final changes = {
        User.FIELD_AVAILABLE: status,
      };

      return await _updateUserMapUseCase.update(state.user!.id, changes);
    }
    return false;
  }

  void _nextState({
    User? user,
    String? businessId,
  }) {
    emit(WaitingState(
      user: user ?? state.user,
      businessId: businessId ?? state.businessId,
    ));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

class WaitingState {
  final User? user;
  final String? businessId;

  WaitingState({
    this.user = null,
    this.businessId = null,
  });
}
