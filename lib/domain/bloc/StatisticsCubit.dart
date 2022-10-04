import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/domain/usecases/incoming/GetProductsIncomingUseCase.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/Product.dart';
import '../../data/models/Sales.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractIncomingRepository.dart';
import '../../data/repositories/AbstractProductRepository.dart';
import '../../data/repositories/AbstractSalesRepository.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../usecases/sales/GetProductsSalesUseCase.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final AbstractProductRepository productRepository;
  final AbstractSalesRepository salesRepository;
  final AbstractIncomingRepository incomingRepository;

  late GetProductsSalesUseCase _getProductsSalesUseCase;
  late GetProductsIncomingUseCase _getProductsIncomingUseCase;

  final _salesController = BehaviorSubject<Map<Product, List<Sales>>?>();
  final _incomingController = BehaviorSubject<Map<Product, List<Incoming>>?>();

  final _cubitController = StreamController<StatisticsState>();

  StatisticsCubit({
    required this.productRepository,
    required this.salesRepository,
    required this.incomingRepository,
  }) : super(StatisticsState());

  void init(Map<dynamic, dynamic> args) {
    _getProductsSalesUseCase = GetProductsSalesUseCase(salesRepository: salesRepository);
    _getProductsIncomingUseCase = GetProductsIncomingUseCase(incomingRepository: incomingRepository);

    _newState(user: args[user_args]);

    _listenStreams();
  }

  void setOrder() => _newState(descending: !state.descending);

  void setDateValues(DateValues value) => _newState(dateValues: value);

  Stream<Map<Product, List<Sales>>?> get listSalesProduct => _salesController.stream;

  Stream<Map<Product, List<Incoming>>?> get listIncomingProduct => _incomingController.stream;

  Future<Map<Product, List<Sales>>?> _getProductsSalesStream() async {
    final results = await _getProductsSalesUseCase.get(state.user!.idBusiness, state.dateValues);

    return results.isEmpty ? null : Map.fromEntries(
      results.entries.toList()
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

  Future<Map<Product, List<Incoming>>?> _getProductsIncomingStream() async {
    final results = await _getProductsIncomingUseCase.get(state.user!.idBusiness, state.dateValues);

    return results.isEmpty ? null : Map.fromEntries(
      results.entries.toList()
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

  void _listenStreams() {
    _cubitController.stream.listen((_) async {
      _salesController.add({});
      _salesController.addStream(_getProductsSalesStream().asStream());

      _incomingController.add({});
      _incomingController.addStream(_getProductsIncomingStream().asStream());
    });
  }

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
    _cubitController.add(state);
  }

  @override
  Future<void> close() {
    _cubitController.close();
    _salesController.close();
    return super.close();
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
