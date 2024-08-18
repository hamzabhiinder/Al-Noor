import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/login_repository.dart';

// Events
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// States
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;

  LoginSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial());

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final data = await loginRepository.login(event.email, event.password);
        yield LoginSuccess(data: data);
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
