

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/logout/logout_event.dart';
import 'package:fun_app/blocs/logout/logout_state.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:meta/meta.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final FirebaseUserAuth userAuth;

  LogoutBloc({@required this.userAuth});

  @override
  get initialState => LogoutInitial();

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if(event is LogoutButtonPressed) {
      await userAuth.signOut();
      yield LogoutSuccess();
    }
  }
}
