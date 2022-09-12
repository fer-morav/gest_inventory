import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/User.dart';
import '../../data/repositories/AbstractUserRepository.dart';
import '../usecases/user/GetUserUseCase.dart';
import '../../utils/arguments.dart';

class HomeCubit extends Cubit<HomeState> {
  final AbstractUserRepository userRepository;

  late GetUserUseCase _getUserUseCase;

  HomeCubit(this.userRepository) : super(HomeState());

  void init(Map<dynamic, dynamic> args) async {
    if (args.isEmpty) {
      return;
    }

    String? userId = args[user_id_args];

    if (userId == null) {
      emit(HomeState(userId: null));
      return;
    }

    _getUserUseCase = GetUserUseCase(userRepository: userRepository);

    User? user = await _getUserUseCase.get(userId);

    emit(HomeState(userId: userId, user: user));
  }

  void reset() => emit(HomeState());
}

class HomeState {
  final String? userId;
  final User? user;

  HomeState({
    this.userId = null,
    this.user = null,
  });
}
