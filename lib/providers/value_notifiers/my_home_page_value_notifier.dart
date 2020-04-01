

import 'package:flutter/cupertino.dart';

class SelectedPage with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  set selectedPage(int value) {
    _selectedPage = value;
    notifyListeners();
  }
}