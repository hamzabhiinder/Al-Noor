// blocs/login_bloc.dart

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

class LoginOfflineSuccess extends LoginState {
  final Map<String, dynamic> data;

  LoginOfflineSuccess({required this.data});

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

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    print('Login button pressed with email: ${event.email}');
    emit(LoginLoading());

    try {
      final data = await loginRepository.login(event.email, event.password);

      if (data['status'] == 'success' && data['message'] == 'Logged in offline') {
        // Offline login success
        print('Emitting LoginOfflineSuccess for ${event.email}');
        emit(LoginOfflineSuccess(data: data));
      } else {
        // Online login success
        print('Emitting LoginSuccess for ${event.email}');
        emit(LoginSuccess(data: data));
      }
    } catch (error) {
      print('Login failed for ${event.email}: $error');
      emit(LoginFailure(error: error.toString()));
    }
  }
}
