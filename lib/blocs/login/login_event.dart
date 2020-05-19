part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email, password;

  const LoginButtonPressed(this.email, this.password);

  @override
  List<Object> get props => [email, password];

}