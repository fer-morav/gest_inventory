import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/domain/usecases/incoming/GetListIncomingTodayUseCase.dart';
import 'package:gest_inventory/domain/usecases/incoming/GetListIncomingUseCase.dart';
import 'package:gest_inventory/domain/usecases/sales/GetSalesMonthUseCase.dart';
import 'package:gest_inventory/domain/usecases/sales/GetSalesTodayUseCase.dart';
import 'package:gest_inventory/domain/usecases/sales/GetSalesWeekUseCase.dart';
import '../../data/models/Sales.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractIncomingRepository.dart';
import '../../data/repositories/AbstractProductRepository.dart';
import '../../data/repositories/AbstractSalesRepository.dart';
import '../../utils/arguments.dart';
import '../../utils/enums.dart';
import '../usecases/incoming/GetListIncomingMonthUseCase.dart';
import '../usecases/incoming/GetListIncomingWeekUseCase.dart';
import '../usecases/product/GetProductsUseCase.dart';
import '../usecases/sales/GetSalesUseCase.dart';

class InformCubit extends Cubit<InformState> {
  final AbstractProductRepository productRepository;
  final AbstractSalesRepository salesRepository;
  final AbstractIncomingRepository incomingRepository;

  late GetProductsUseCase _getProductsUseCase;

  late GetSalesUseCase _getSalesUseCase;
  late GetSalesTodayUseCase _getSalesTodayUseCase;
  late GetSalesWeekUseCase _getSalesWeekUseCase;
  late GetSalesMonthUseCase _getSalesMonthUseCase;

  late GetListIncomingUseCase _getListIncomingUseCase;
  late GetListIncomingTodayUseCase _getListIncomingTodayUseCase;
  late GetListIncomingWeekUseCase _getListIncomingWeekUseCase;
  late GetListIncomingMonthUseCase _getListIncomingMonthUseCase;

  final _dateValuesController = StreamController<InformState>();

  InformCubit({
    required this.productRepository,
    required this.salesRepository,
    required this.incomingRepository,
  }) : super(InformState(salesProducts: [], entriesProducts: []));

  void init(Map<dynamic, dynamic> args) {
    _getProductsUseCase = GetProductsUseCase(productRepository: productRepository);

    _getSalesUseCase = GetSalesUseCase(salesRepository: salesRepository);
    _getSalesTodayUseCase = GetSalesTodayUseCase(salesRepository: salesRepository);
    _getSalesWeekUseCase = GetSalesWeekUseCase(salesRepository: salesRepository);
    _getSalesMonthUseCase = GetSalesMonthUseCase(salesRepository: salesRepository);

    _getListIncomingUseCase = GetListIncomingUseCase(incomingRepository: incomingRepository);
    _getListIncomingTodayUseCase = GetListIncomingTodayUseCase(incomingRepository: incomingRepository);
    _getListIncomingWeekUseCase = GetListIncomingWeekUseCase(incomingRepository: incomingRepository);
    _getListIncomingMonthUseCase = GetListIncomingMonthUseCase(incomingRepository: incomingRepository);

    _newState(user: args[user_args]);

    _listenDateValues();
  }

  void setDateValues(DateValues value) => _newState(dateValues: value);

  void _listenDateValues() {
    _dateValuesController.stream.listen((_) => _getProducts());
  }

  void setCurrentSortColumnSales(int index) {
    _newState(currentSortColumnSales: index, ascendingSales: !state.ascendingSales);
    _sortSalesColumn();
  }

  void _sortSalesColumn() {
    switch(state.currentSortColumnSales) {
      case 2:
        _newState(
          salesProducts: state.salesProducts
            ..sort(
              (p1, p2) => state.ascendingSales
                  ? p1.unitSold.compareTo(p2.unitSold)
                  : -p1.unitSold.compareTo(p2.unitSold),
            ),
        );
        break;
      case 3:
        _newState(
          salesProducts: state.salesProducts
            ..sort(
              (p1, p2) => state.ascendingSales
                  ? p1.wholeSaleSold.compareTo(p2.wholeSaleSold)
                  : -p1.wholeSaleSold.compareTo(p2.wholeSaleSold),
            ),
        );
        break;
      case 4:
        _newState(
          salesProducts: state.salesProducts
            ..sort(
              (p1, p2) => state.ascendingSales
                  ? p1.total.compareTo(p2.total)
                  : -p1.total.compareTo(p2.total),
            ),
        );
        break;

    }
  }

  void _getProducts() async {
    if (state.user != null && state.user!.idBusiness.isNotEmpty) {
      List<_ModelSalesInform> resultSales = [];
      List<_ModelEntriesInform> resultEntries = [];

      final products = await _getProductsUseCase.getList(state.user!.idBusiness);

      for (final product in products) {
        List<Sales> sales = [];
        List<Incoming> entries = [];


        switch(state.dateValues) {
          case DateValues.today:
            sales.clear();
            entries.clear();

            sales = await _getSalesTodayUseCase.get(product.id);
            entries = await _getListIncomingTodayUseCase.get(product.id);
            break;
          case DateValues.week:
            sales.clear();
            entries.clear();

            sales = await _getSalesWeekUseCase.get(product.id);
            entries = await _getListIncomingWeekUseCase.get(product.id);
            break;
          case DateValues.month:
            sales.clear();
            entries.clear();

            sales = await _getSalesMonthUseCase.get(product.id);
            entries = await _getListIncomingMonthUseCase.get(product.id);
            break;
          case DateValues.year:
            sales.clear();
            entries.clear();

            sales = await _getSalesUseCase.getSales(product.id);
            entries = await _getListIncomingUseCase.get(product.id);
            break;
        }

        int totalUnitSold = _calculateUnitSold(sales);
        int totalWholeSaleSold = _calculateWholeSaleSold(sales);
        int totalEntries = _calculateUnits(entries);

        double total = (totalUnitSold * product.unitPrice) + (totalWholeSaleSold * product.wholesalePrice);

        final modelSales = _ModelSalesInform(product, totalUnitSold, totalWholeSaleSold, total);
        final modelEntries = _ModelEntriesInform(product, totalEntries);

        resultSales.add(modelSales);
        resultEntries.add(modelEntries);
      }

      if (!this.isClosed) {
        _newState(salesProducts: resultSales, entriesProducts: resultEntries);
      }
    }
  }

  int _calculateWholeSaleSold(List<Sales> sales) {
    var result = 0;

    sales.forEach((sale) {
      if (sale.units >= 10) {
        result += sale.units.toInt();
      }
    });

    return result;
  }

  int _calculateUnitSold(List<Sales> sales) {
    var result = 0;

    sales.forEach((sale) {
      if (sale.units < 10) {
        result += sale.units.toInt();
      }
    });

    return result;
  }

  int _calculateUnits(List<Incoming> entries) {
    var result = 0;

    entries.forEach((entry) => result += entry.units.toInt());

    return result;
  }

  int totalWholeSaleSold() {
    var result = 0;

    state.salesProducts.forEach((product) => result += product.wholeSaleSold);

    return result;
  }

  int totalUnitSold() {
    var result = 0;

    state.salesProducts.forEach((product) => result += product.unitSold);

    return result;
  }

  double totalSales() {
    var result = 0.0;

    state.salesProducts.forEach((product) => result += product.total);

    return result;
  }

  int totalEntries() {
    var result = 0;

    state.entriesProducts.forEach((product) => result += product.unitsEntries);

    return result;
  }

  void _newState({
    User? user,
    DateValues? dateValues,
    bool? ascendingSales,
    int? currentSortColumnSales,
    List<_ModelSalesInform>? salesProducts,
    List<_ModelEntriesInform>? entriesProducts,
  }) {
    emit(InformState(
      user: user ?? state.user,
      dateValues: dateValues ?? state.dateValues,
      ascendingSales: ascendingSales ?? state.ascendingSales,
      currentSortColumnSales: currentSortColumnSales ?? state.currentSortColumnSales,
      salesProducts: salesProducts ?? state.salesProducts,
      entriesProducts: entriesProducts ?? state.entriesProducts,
    ));

    _dateValuesController.add(state);
  }

  @override
  Future<void> close() {
    _dateValuesController.close();
    return super.close();
  }
}

class InformState {
  final User? user;
  final DateValues dateValues;
  final bool ascendingSales;
  final int currentSortColumnSales;
  final List<_ModelSalesInform> salesProducts;
  final List<_ModelEntriesInform> entriesProducts;

  InformState({
    this.user = null,
    this.dateValues = DateValues.year,
    this.ascendingSales = true,
    this.currentSortColumnSales = 0,
    required this.salesProducts,
    required this.entriesProducts,
  });
}

class _ModelSalesInform {
  final Product product;
  final int unitSold;
  final int wholeSaleSold;
  final double total;

  _ModelSalesInform(
    this.product,
    this.unitSold,
    this.wholeSaleSold,
    this.total,
  );
}

class _ModelEntriesInform {
  final Product product;
  final int unitsEntries;

  _ModelEntriesInform(
    this.product,
    this.unitsEntries,
  );
}
