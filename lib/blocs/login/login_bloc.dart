import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseUserAuth userAuth;

  LoginBloc({@required this.userAuth});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      try {
        yield LoginLoading();
        FirebaseUser user =
            await userAuth.loginUser(event.email, event.password);
        yield LoginLoaded(user: user);
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
  }
}
