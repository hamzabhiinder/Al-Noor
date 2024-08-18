import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/register_repository.dart';

// Events
abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterButtonPressed({required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

// States
abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> data;

  RegisterSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  void _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      final data = await registerRepository.register(event.name, event.email, event.password);
      emit(RegisterSuccess(data: data));
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }
  }
}
