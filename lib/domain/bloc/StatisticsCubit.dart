import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/Product.dart';
import '../../data/models/Sales.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractProductRepository.dart';
import '../../data/repositories/AbstractSalesRepository.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../usecases/sales/GetProductsSalesUseCase.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final AbstractProductRepository productRepository;
  final AbstractSalesRepository salesRepository;

  late GetProductsSalesUseCase _getSalesUseCase;

  StatisticsCubit({
    required this.productRepository,
    required this.salesRepository,
  }) : super(StatisticsState());

  void init(Map<dynamic, dynamic> args) {
    _getSalesUseCase =
        GetProductsSalesUseCase(salesRepository: salesRepository);

    _newState(user: args[user_args]);
  }

  Stream<Map<Product, List<Sales>>> getProductsSales(String businessId, DateValues value) async* {
    final snapshots = await _getSalesUseCase.get(businessId, value);

    await for (final snapshot in snapshots) {
      yield Map.fromEntries(
        snapshot.entries.toList()
          ..sort(
            (a, b) {
              var unitsA = 0.0, unitsB = 0.0;

              a.value.forEach((sales) => unitsA += sales.units);
              b.value.forEach((sales) => unitsB += sales.units);

              return state.descending
                  ? -unitsA.compareTo(unitsB)
                  : unitsA.compareTo(unitsB);
            },
          ),
      );
    }
  }

  void setOrder() => _newState(descending: !state.descending);

  void setDateValues(DateValues value) => _newState(dateValues: value);

  void _newState({
    User? user,
    bool? descending,
    DateValues? dateValues,
  }) {
    emit(StatisticsState(
      user: user ?? state.user,
      descending: descending ?? state.descending,
      dateValues: dateValues ?? state.dateValues,
    ));
  }
}

class StatisticsState {
  final User? user;
  final bool descending;
  final DateValues dateValues;

  StatisticsState({
    this.user = null,
    this.descending = true,
    this.dateValues = DateValues.year,
  });
}
