import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'package:gest_inventory/utils/enums.dart';
import '../../../data/models/Incoming.dart';
import '../product/GetProductsUseCase.dart';

class GetProductsIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;
  final GetProductsUseCase _getProductsUseCase = GetProductsUseCase(productRepository: ProductDataSource());

  GetProductsIncomingUseCase({required this.incomingRepository});

  Future<Map<Product, List<Incoming>>> get(String businessId, DateValues dateValues) async {
    Map<Product, List<Incoming>> result = {};

    final products = await _getProductsUseCase.getList(businessId);

    for (final product in products) {
      List<Incoming> incoming = [];

      switch (dateValues) {
        case DateValues.today:
          incoming.clear();
          incoming = await incomingRepository.getListIncomingToday(product.id);
          break;
        case DateValues.week:
          incoming.clear();
          incoming = await incomingRepository.getListIncomingWeek(product.id);
          break;
        case DateValues.month:
          incoming.clear();
          incoming = await incomingRepository.getListIncomingMonth(product.id);
          break;
        case DateValues.year:
          incoming.clear();
          incoming = await incomingRepository.getListIncoming(product.id);
          break;
      }

      if (incoming.isNotEmpty) {
        result[product] = incoming;
      }
    }
    return result;
  }
}