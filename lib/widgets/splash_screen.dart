import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(
                "assets/images/loading.gif", fit: BoxFit.cover,
              ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/loading2.gif",
              width: 200, 
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
