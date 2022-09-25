import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractUserRepository.dart';
import '../../utils/enums.dart';
import '../../utils/arguments.dart';
import '../usecases/user/GetUsersAvailableUseCase.dart';
import '../usecases/user/GetUsersUseCase.dart';
import '../usecases/user/UpdateUserMapUseCase.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final AbstractUserRepository userRepository;

  late GetUsersUseCase _getUsersUseCase;
  late UpdateUserMapUseCase _updateUserMapUseCase;
  late GetUsersAvailableUseCase _getUsersAvailableUseCase;

  EmployeesCubit({required this.userRepository}) : super(EmployeesState());

  void init(Map<dynamic, dynamic> args) {
    _getUsersUseCase = GetUsersUseCase(userRepository: userRepository);
    _updateUserMapUseCase = UpdateUserMapUseCase(userRepository: userRepository);
    _getUsersAvailableUseCase = GetUsersAvailableUseCase(userRepository: userRepository);

    _newState(user: args[user_args], actionType: ActionType.select);
  }

  void setAction(ActionType action) => _newState(actionType: action);

  Stream<List<User>> listStreamUsers(String businessId) => _getUsersUseCase.getUsers(businessId);

  Future<List<User>> listUsers(String businessId) => _getUsersUseCase.getList(businessId);

  Stream<List<User>> availableUsers() => _getUsersAvailableUseCase.get();

  Future<void> _updateUser(String id, Map<String, dynamic> changes) async {
    await _updateUserMapUseCase.update(id, changes);
  }

  void updateValues(String id, bool admin, double salary) {
    final changes = {
      User.FIELD_ADMIN: admin,
      User.FIELD_SALARY: salary,
    };

    _updateUser(id, changes);
  }

  void addEmployee(String userid, String businessId, bool admin, double salary) {
    final changes = {
      User.FIELD_ID_BUSINESS: businessId,
      User.FIELD_AVAILABLE: false,
      User.FIELD_ADMIN: admin,
      User.FIELD_SALARY: salary,
    };

    _updateUser(userid, changes);
  }

  void deleteEmployee(String userId) {
    final changes = {
      User.FIELD_ID_BUSINESS: ""
    };

    _updateUser(userId, changes);
  }

  void _newState({
    User? user,
    ActionType? actionType,
  }) {
    emit(EmployeesState(
      user: user ?? state.user,
      actionType: actionType ?? state.actionType,
    ));
  }
}

class EmployeesState {
  final User? user;
  final ActionType actionType;

  EmployeesState({
    this.user = null,
    this.actionType = ActionType.select,
  });
}
