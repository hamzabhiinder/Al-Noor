import 'package:alnoor/models/product.dart';
import 'package:alnoor/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// Events
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  final String search;
  final String category;

  LoadProducts({required this.search, required this.category});
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final Box<List<dynamic>> productBox;

  ProductBloc(this.repository, this.productBox) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    if (productBox.containsKey('cachedProducts') && event.search.isEmpty && event.category.isEmpty) {
      // Manually cast the cached list to List<Product>
      final cachedProducts = (productBox.get('cachedProducts') as List)
          .map((product) => product as Product)
          .toList();
      emit(ProductLoaded(cachedProducts));
    } else {
      emit(ProductLoading());
      try {
        final products = await repository.fetchProducts(event.search, event.category);
        productBox.put('cachedProducts', products);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to load products'));
      }
    }
  }
}
