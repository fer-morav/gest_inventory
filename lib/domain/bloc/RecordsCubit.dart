import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'package:gest_inventory/domain/usecases/incoming/GetListIncomingUseCase.dart';
import 'package:gest_inventory/domain/usecases/sales/GetSalesTodayUseCase.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/Sales.dart';
import '../../data/repositories/AbstractSalesRepository.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../usecases/incoming/GetListIncomingMonthUseCase.dart';
import '../usecases/incoming/GetListIncomingTodayUseCase.dart';
import '../usecases/incoming/GetListIncomingWeekUseCase.dart';
import '../usecases/sales/GetSalesMonthUseCase.dart';
import '../usecases/sales/GetSalesUseCase.dart';
import '../usecases/sales/GetSalesWeekUseCase.dart';

class RecordsCubit extends Cubit<RecordsState> {
  final AbstractSalesRepository salesRepository;
  final AbstractIncomingRepository incomingRepository;

  late GetSalesUseCase _getSalesUseCase;
  late GetSalesTodayUseCase _getSalesTodayUseCase;
  late GetSalesWeekUseCase _getSalesWeekUseCase;
  late GetSalesMonthUseCase _getSalesMonthUseCase;

  late GetListIncomingUseCase _getListIncomingUseCase;
  late GetListIncomingTodayUseCase _getListIncomingTodayUseCase;
  late GetListIncomingWeekUseCase _getListIncomingWeekUseCase;
  late GetListIncomingMonthUseCase _getListIncomingMonthUseCase;

  final _salesController = BehaviorSubject<List<Sales>>();
  final _incomingController = BehaviorSubject<List<Incoming>>();

  final _cubitController = StreamController<RecordsState>();

  RecordsCubit({
    required this.salesRepository,
    required this.incomingRepository,
  }) : super(RecordsState());

  void init(Map<dynamic, dynamic> args) {
    _getSalesUseCase = GetSalesUseCase(salesRepository: salesRepository);
    _getSalesTodayUseCase = GetSalesTodayUseCase(salesRepository: salesRepository);
    _getSalesWeekUseCase = GetSalesWeekUseCase(salesRepository: salesRepository);
    _getSalesMonthUseCase = GetSalesMonthUseCase(salesRepository: salesRepository);

    _getListIncomingUseCase = GetListIncomingUseCase(incomingRepository: incomingRepository);
    _getListIncomingTodayUseCase = GetListIncomingTodayUseCase(incomingRepository: incomingRepository);
    _getListIncomingWeekUseCase = GetListIncomingWeekUseCase(incomingRepository: incomingRepository);
    _getListIncomingMonthUseCase = GetListIncomingMonthUseCase(incomingRepository: incomingRepository);


    _newState(product: args[product_args]);

    _cubitController.stream.listen((_) {_salesStream(); _incomingStream();});
  }

  void setValues(DateValues value) => _newState(dateValues: value);

  void setOrder() => _newState(descending: !state.descending);

  Stream<List<Sales>> get listSales => _salesController.stream;

  Stream<List<Incoming>> get listIncoming => _incomingController.stream;

  void _salesStream() {
    switch (state.dateValues) {
      case DateValues.today:
        _salesController.addStream(_getSalesTodayUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.week:
        _salesController.addStream(_getSalesWeekUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.month:
        _salesController.addStream(_getSalesMonthUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.year:
        _salesController.addStream(_getSalesUseCase
            .getSales(state.product!.id, descending: state.descending)
            .asStream());
        break;
    }
  }

  void _incomingStream() {
    switch (state.dateValues) {
      case DateValues.today:
        _incomingController.addStream(_getListIncomingTodayUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.week:
        _incomingController.addStream(_getListIncomingWeekUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.month:
        _incomingController.addStream(_getListIncomingMonthUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
      case DateValues.year:
        _incomingController.addStream(_getListIncomingUseCase
            .get(state.product!.id, descending: state.descending)
            .asStream());
        break;
    }
  }

  void _newState({
    Product? product,
    bool? descending,
    DateValues? dateValues,
  }) {
    emit(RecordsState(
      product: product ?? state.product,
      descending: descending ?? state.descending,
      dateValues: dateValues ?? state.dateValues,
    ));
    _cubitController.add(state);
  }

  @override
  Future<void> close() {
    _cubitController.close();
    return super.close();
  }
}

class RecordsState {
  final Product? product;
  final bool descending;
  final DateValues dateValues;

  RecordsState({
    this.product = null,
    this.descending = true,
    this.dateValues = DateValues.year,
  });
}