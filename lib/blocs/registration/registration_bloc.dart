import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  FirebaseUserAuth userAuth;

  RegistrationBloc({this.userAuth});

  @override
  RegistrationState get initialState => RegistrationInitial();

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is RegisterButtonPressed) {
      try {
        yield RegistrationLoading(); 
        FirebaseUser user =
            await userAuth.registerUser(event.email, event.password);
        if(event.fileName != null) {
          StorageReference ref = await userAuth.uplodadImage(event.imageName);
          String _imageUrl = await ref.getDownloadURL();
          await userAuth.userData(event.email, event.password, user.uid, event.username, _imageUrl);
        } else {
          await userAuth.userData(event.email, event.password, user.uid, event.username, "");
        }
        
        yield RegistrationLoaded(user: user);
      } catch (e) {
        RegistrationError(e.toString());
      }
    }
  }
}
