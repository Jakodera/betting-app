import 'package:flutter/material.dart';
import 'package:fun_app/my_home_page.dart';
import 'package:fun_app/services/auth/auth.dart';
import 'package:fun_app/services/auth/auth_widget.dart';
import 'package:fun_app/services/auth/auth_widget_builder.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseAuth>(
          create: (_) => Auth(),
        ),
      ],
      child: AuthWidgetBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            home: AuthWidget(userSnapshot: userSnapshot),
            theme: ThemeData(canvasColor: Colors.black),
            routes: {
              "/home": (context) => MyHomePage(),
            },
          );
        },
      ),
    );
  }
}
