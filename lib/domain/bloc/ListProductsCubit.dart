import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/models/Product.dart';
import 'package:gest_inventory/data/models/User.dart';
import 'package:gest_inventory/utils/actions_enum.dart';
import '../../data/repositories/AbstractProductRepository.dart';
import '../../utils/arguments.dart';
import '../usecases/product/DeleteProductUseCase.dart';
import '../usecases/product/GetProductsUseCase.dart';

class ListProductsCubit extends Cubit<ListProductsState> {
  final AbstractProductRepository productRepository;

  late GetProductsUseCase _getProductsUseCase;
  late DeleteProductUseCase _deleteProductUseCase;

  ListProductsCubit({required this.productRepository}) : super(ListProductsState());

  void init(Map<dynamic, dynamic> args) {
    _getProductsUseCase = GetProductsUseCase(productRepository: productRepository);
    _deleteProductUseCase = DeleteProductUseCase(productRepository: productRepository);

    _newState(user: args[user_args], actionType: ActionType.select);
  }

  void setAction(ActionType action) => _newState(actionType: action);

  Stream<List<Product>> listStreamProducts() => _getProductsUseCase.getProducts(state.user!.idBusiness);

  Future<List<Product>> listProducts() => _getProductsUseCase.getList(state.user!.idBusiness);

  void deleteProduct(Product product) async {
    await _deleteProductUseCase.delete(product);
  }

  void _newState({
    User? user,
    ActionType? actionType,
  }) {
    emit(ListProductsState(
      user: user ?? state.user,
      actionType: actionType ?? state.actionType,
    ));
  }
}

class ListProductsState {
  final User? user;
  final ActionType actionType;

  ListProductsState({
    this.user = null,
    this.actionType = ActionType.select,
  });
}