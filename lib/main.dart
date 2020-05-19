import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:fun_app/providers/value_notifiers/league_selected_value_notifier.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';
import 'package:fun_app/services/auth/auth_widget_builder.dart';
import 'package:fun_app/services/auth/register_page.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:fun_app/widgets/splash_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseUserAuth userAuth = FirebaseUserAuth();

  @override
  Widget build(BuildContext context) {
    // Osnovni provideri koji ne ovise o korisniku
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BetProvider>(
          create: (_) => BetProvider(),
        ),
        ChangeNotifierProvider<SelectedPage>(
          create: (_) => SelectedPage(),
        ),
        ChangeNotifierProvider<LeagueLogoSelected>(
          create: (_) => LeagueLogoSelected(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fun Bet",
        theme:
            ThemeData(primaryColor: Colors.black, canvasColor: Colors.black),
        home: BlocProvider(
          create: (context) =>
              AuthenticationBloc(userAuth: userAuth)..add(AppStarted()),
          child: App(
            userAuth: userAuth,
          ),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  final FirebaseUserAuth userAuth;

  App({@required this.userAuth});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return SplashScreen();
        } else if (state is Authenticated) {
          return AuthWidgetBuilder(
            userId: state.user.uid,
            userAuth: userAuth,
          );
        } else if (state is Unauthenticated) {
          return RegisterPageParent(
            userAuth: userAuth,
          );
        }
        return Container();
      },
    );
  }
}
