part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final UserModel user;
  
  const AuthSignUpSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthLoginSuccess extends AuthState {
  final UserModel user;
  
  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;
  
  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}