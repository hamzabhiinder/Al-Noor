import 'package:alnoor/models/category.dart';
import 'package:alnoor/repositories/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// Events
abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

// States
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

// BLoC
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      // Load categories from Hive if offline
      var box = Hive.box('categoriesBox');
      if (box.containsKey('categories')) {
        final cachedCategories = box.get('categories') as List<dynamic>;
        final categories = cachedCategories
            .map((item) => Category.fromJson(item))
            .toList();
        emit(CategoryLoaded(categories));
      } else {
        emit(CategoryError('Failed to load categories'));
      }
    }
  }
}
