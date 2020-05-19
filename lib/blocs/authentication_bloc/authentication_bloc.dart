import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseUserAuth userAuth;

  AuthenticationBloc({this.userAuth});

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      try {
        bool isSignedIn = await userAuth.isLogged();
        if (isSignedIn) {
          FirebaseUser user = await userAuth.currentUser();
          yield Authenticated(user: user);
        } else {
          yield Unauthenticated();
        }
      } catch (e) {
        yield Unauthenticated(message: "Something went wrong! Please try again...");
      }
    }
  }
}
