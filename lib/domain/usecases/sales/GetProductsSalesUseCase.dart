import 'package:gest_inventory/data/datasource/firebase/ProductDataSource.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/utils/enums.dart';
import '../../../data/models/Sales.dart';
import '../../../data/repositories/AbstractSalesRepository.dart';
import '../product/GetProductsUseCase.dart';

class GetProductsSalesUseCase {
  final AbstractSalesRepository salesRepository;
  final GetProductsUseCase _getProductsUseCase =
      GetProductsUseCase(productRepository: ProductDataSource());

  GetProductsSalesUseCase({required this.salesRepository});

  Stream<Map<Product, List<Sales>>> get(String businessId, DateValues dateValues) async* {
    Map<Product, List<Sales>> result = {};

    final snapshots = await _getProductsUseCase.getProducts(businessId);

    await for (final products in snapshots) {
      for (final product in products) {

        List<Sales> sales = [];

        switch(dateValues) {
          case DateValues.today:
            sales.clear();
            sales = await salesRepository.getSalesToday(product.id);
            break;
          case DateValues.week:
            sales.clear();
            sales = await salesRepository.getSalesWeek(product.id);
            break;
          case DateValues.month:
            sales.clear();
            sales = await salesRepository.getSalesMonth(product.id);
            break;
          case DateValues.year:
            sales.clear();
            sales = await salesRepository.getSales(product.id);
            break;
        }

        if (sales.isNotEmpty) {
          result[product] = sales;
        }
        yield result;
      }
    }
  }
}
