import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {}