part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String deviceName;

  const LoginRequested(this.email, this.password, this.deviceName);

  @override
  List<Object> get props => [email, password, deviceName];
}