import 'package:flutter/cupertino.dart';

class LeagueLogoSelected with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  void getIndex(int value) {
    index = value;
    notifyListeners();
  }
}
