part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded  extends LoginState {
  final FirebaseUser user;

  const LoginLoaded({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoginError  extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}