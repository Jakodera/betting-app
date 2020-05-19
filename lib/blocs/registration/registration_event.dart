part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegisterButtonPressed extends RegistrationEvent {
  final String email, password, username, fileName;
  final File imageName;

  const RegisterButtonPressed(
      {@required this.email,
      @required this.password,
      @required this.username,
      this.fileName,
      this.imageName});

  @override
  List<Object> get props => [email, password, username, fileName, imageName];
}
