part of 'bet_bloc.dart';

abstract class BetEvent extends Equatable {
  const BetEvent();
}

class BetPlacedButtonClicked extends BetEvent {
  final Map<String, dynamic> ticketInfo;
  final Map<String, dynamic> userProfile;
  final List<OddModel> matches; 

  const BetPlacedButtonClicked(this.ticketInfo, this.userProfile, this.matches);

  @override
  List<Object> get props => [ticketInfo, userProfile, matches];

}
