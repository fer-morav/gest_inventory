import 'package:gest_inventory/data/models/User.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/AbstractUserRepository.dart';

class UserCubit extends Cubit<UserState> {
  final AbstractUserRepository _userRepository;
  User? _user;

  UserCubit(this._userRepository) : super(UserLoadingState());

  Future<void> reset() async => emit(UserLoadingState());

  Future<User?> getUser(String id) async {
    emit(UserLoadingState());

    _user = await _userRepository.getUser(id);

    emit(UserReadyState(_user));
    return _user;
  }

  Future<bool> addUser(User user) async {
    emit(UserLoadingState());

    final result = await _userRepository.addUser(user);

    emit(UserReadyState(user));

    return result;
  }

  Future<bool> updateUser(User user) async {
    emit(UserLoadingState());

    final result = await _userRepository.updateUser(user);

    emit(UserReadyState(user));

    return result;
  }

  Stream<List<User>> getUsers(String businessId) => _userRepository.getUsers(businessId);


  Future<bool> deleteUser(String id) async {
    emit(UserLoadingState());

    final result = await _userRepository.deleteUser(id);

    emit(UserReadyState(_user));

    return result;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

abstract class UserState {}

class UserLoadingState extends UserState{}

class UserReadyState extends UserState {
  final User? user;

  UserReadyState(this.user);
}

