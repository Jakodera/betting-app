import 'package:flutter/material.dart';
import 'package:fun_app/my_home_page.dart';
import 'package:fun_app/services/auth/login_page.dart';

class AuthWidget extends StatelessWidget {
  final AsyncSnapshot<String> userSnapshot;

  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? MyHomePage() : LoginPage();
    }
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
