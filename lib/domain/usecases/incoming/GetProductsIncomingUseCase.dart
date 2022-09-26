import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/models/Incoming.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/repositories/AbstractIncomingRepository.dart';
import 'package:gest_inventory/utils/enums.dart';
import '../product/GetProductsUseCase.dart';

class GetProductsIncomingUseCase {
  final AbstractIncomingRepository incomingRepository;
  final GetProductsUseCase _getProductsUseCase = GetProductsUseCase(productRepository: ProductDataSource());

  GetProductsIncomingUseCase({required this.incomingRepository});

  Stream<Map<Product, List<Incoming>>> get(String businessId, DateValues dateValues) async* {
    Map<Product, List<Incoming>> result = {};

    final snapshots = await _getProductsUseCase.getProducts(businessId);

    await for (final products in snapshots) {
      for (final product in products) {

        List<Incoming> listIncoming = [];

        switch(dateValues) {
          case DateValues.today:
            listIncoming.clear();
            listIncoming = await incomingRepository.getListIncomingToday(product.id);
            break;
          case DateValues.week:
            listIncoming.clear();
            listIncoming = await incomingRepository.getListIncomingWeek(product.id);
            break;
          case DateValues.month:
            listIncoming.clear();
            listIncoming = await incomingRepository.getListIncomingMonth(product.id);
            break;
          case DateValues.year:
            listIncoming.clear();
            listIncoming = await incomingRepository.getListIncoming(product.id);
            break;
        }

        if (listIncoming.isNotEmpty) {
          result[product] = listIncoming;
        }
        yield result;
      }
    }
  }
}