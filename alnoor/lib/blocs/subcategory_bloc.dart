// subcategory_bloc.dart

// Events
import 'package:alnoor/repositories/subcategory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubcategoryEvent {}

class LoadSubcategories extends SubcategoryEvent {}

// States
abstract class SubcategoryState {}

class SubcategoryInitial extends SubcategoryState {}

class SubcategoryLoading extends SubcategoryState {}

class SubcategoryLoaded extends SubcategoryState {
  final List<dynamic> subcategories;
  SubcategoryLoaded(this.subcategories);
}

class SubcategoryError extends SubcategoryState {
  final String message;
  SubcategoryError(this.message);
}

// BLoC
class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final SubcategoryRepository repository;

  SubcategoryBloc(this.repository) : super(SubcategoryInitial()) {
    on<LoadSubcategories>(_onLoadSubcategories);
  }

  Future<void> _onLoadSubcategories(
      LoadSubcategories event, Emitter<SubcategoryState> emit) async {
    emit(SubcategoryLoading());
    try {
      final categories = await repository.fetchSubcategories();
      emit(SubcategoryLoaded(categories));
    } catch (e) {
      emit(SubcategoryError('Failed to load categories'));
    }
  }
}
