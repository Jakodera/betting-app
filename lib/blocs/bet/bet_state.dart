part of 'bet_bloc.dart';

abstract class BetState extends Equatable {
  const BetState();
}

class BetInitial extends BetState {
  @override
  List<Object> get props => [];
}

class BetLoading extends BetState {
  @override
  List<Object> get props => [];
}

class BetLoaded extends BetState {
  final String message;

  BetLoaded({this.message});

  @override
  List<Object> get props => [message];
}

class BetError extends BetState {
  @override
  List<Object> get props => [];
}
