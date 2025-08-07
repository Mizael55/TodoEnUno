part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpWithEmailAndPasswordRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String userType;

  const SignUpWithEmailAndPasswordRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.userType,
  });

  @override
  List<Object> get props => [email, password, fullName, userType];
}

class SignUpWithGoogleRequested extends AuthEvent {
  final String userType;

  const SignUpWithGoogleRequested({required this.userType});

  @override
  List<Object> get props => [userType];
}

class LoginWithEmailAndPasswordRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailAndPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginWithGoogleRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}