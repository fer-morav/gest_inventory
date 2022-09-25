import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/domain/usecases/sales/GetSalesTodayUseCase.dart';
import '../../data/models/Sales.dart';
import '../../data/repositories/AbstractSalesRepository.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../usecases/sales/GetSalesMonthUseCase.dart';
import '../usecases/sales/GetSalesUseCase.dart';
import '../usecases/sales/GetSalesWeekUseCase.dart';

class SalesCubit extends Cubit<SalesState> {
  final AbstractSalesRepository salesRepository;

  late GetSalesUseCase _getSalesUseCase;
  late GetSalesTodayUseCase _getSalesTodayUseCase;
  late GetSalesWeekUseCase _getSalesWeekUseCase;
  late GetSalesMonthUseCase _getSalesMonthUseCase;

  SalesCubit({required this.salesRepository}) : super(SalesState());

  void init(Map<dynamic, dynamic> args) {
    _getSalesUseCase = GetSalesUseCase(salesRepository: salesRepository);
    _getSalesTodayUseCase = GetSalesTodayUseCase(salesRepository: salesRepository);
    _getSalesWeekUseCase = GetSalesWeekUseCase(salesRepository: salesRepository);
    _getSalesMonthUseCase = GetSalesMonthUseCase(salesRepository: salesRepository);

    _newState(product: args[product_args]);
  }

  void setValues(DateValues value) => _newState(dateValues: value);

  void setOrder() => _newState(descending: !state.descending);

  Stream<List<Sales>> salesStream(DateValues dateValues) {
    switch(dateValues) {
      case DateValues.today:
        return _getSalesTodayUseCase.get(state.product!.id, descending: state.descending).asStream();
      case DateValues.week:
        return _getSalesWeekUseCase.get(state.product!.id, descending: state.descending).asStream();
      case DateValues.month:
        return _getSalesMonthUseCase.get(state.product!.id, descending: state.descending).asStream();
      case DateValues.year:
        return _getSalesUseCase.getSales(state.product!.id, descending: state.descending).asStream();
    }
  }

  void _newState({
    Product? product,
    bool? descending,
    DateValues? dateValues,
  }) {
    emit(SalesState(
      product: product ?? state.product,
      descending: descending ?? state.descending,
      dateValues: dateValues ?? state.dateValues,
    ));
  }
}

class SalesState {
  final Product? product;
  final bool descending;
  final DateValues dateValues;

  SalesState({
    this.product = null,
    this.descending = true,
    this.dateValues = DateValues.year,
  });
}