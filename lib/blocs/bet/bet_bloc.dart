import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:meta/meta.dart';

part 'bet_event.dart';
part 'bet_state.dart';

class BetBloc extends Bloc<BetEvent, BetState> {
  final FirebaseCrud firebaseCrud;

  BetBloc({@required this.firebaseCrud});

  @override
  BetState get initialState => BetInitial();

  @override
  Stream<BetState> mapEventToState(
    BetEvent event,
  ) async* {
    if (event is BetPlacedButtonClicked) {
      yield BetLoading();
      try {
        // Get Document Reference on Posted Ticket Information and ID in Firestore
        DocumentReference docRef =
            await firebaseCrud.addTicketInfo(event.ticketInfo);

        // Convert Matches from BetProvider into Firestore Map
        List<Map<String, dynamic>> convertedMatches = firebaseCrud.convertMatches(event.matches);

        // Post Matches Into Firestore Database
        String postedMatches = await firebaseCrud.addMatches(convertedMatches, docRef);

        // Update User Profile
        String updatedProfile = await firebaseCrud.updateUserProfile(event.userProfile);
        print(updatedProfile);

        yield BetLoaded(message: postedMatches);

      } catch (e) {
        print(e);
        yield BetError();
      }
    }
  }
}
