import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';

class BetProvider extends ChangeNotifier {
  
  List<OddModel> _oddModel = [];
  double _resultOdd = 1;
  double _cashOut = 0.0;
  int _betInput = 0;


  List<OddModel> get oddModel => _oddModel;
  double get resultOdd => _resultOdd;
  double get cashOut => _cashOut;
  int get betInput => _betInput;

  set oddModel(List<OddModel> model) {
    _oddModel = model;
    notifyListeners();
  }

  set resultOdd(double odd) {
    _resultOdd = odd;
    notifyListeners();
  }

  set cashOut(double value) {
    _cashOut = value;
    notifyListeners();
  }

  set betInput(int input) {
    _betInput = input;
    notifyListeners();
  }

  addMatch(OddModel match) {
    oddModel.add(match);
    oddModel.sort((a, b) {
      return a.minute.compareTo(b.minute);
    });
    if(match.pick == "1") {
      resultOdd *= double.parse(match.coefHost);
    } else if(match.pick == "X") {
      resultOdd *= double.parse(match.coefDraw);
    } else {
      resultOdd *= double.parse(match.coefGuest);
    }
    payOut(_resultOdd, _betInput.toDouble());
  }

  void removeMatch(OddModel match) {
    oddModel.remove(match);
    if(match.pick == "1") {
      resultOdd /= double.parse(match.coefHost);
    } else if(match.pick == "X") {
      resultOdd /= double.parse(match.coefDraw);
    } else {
      resultOdd /= double.parse(match.coefGuest);
    }
    payOut(_resultOdd, _betInput.toDouble());
  }

  void payOut(double odd, double bet) {
    cashOut = odd * bet;
    if(_oddModel.length == 0) {
      _cashOut = 0;
      _betInput = 0;
    }
  }

  void addInput(int value) {
    betInput = value;
  }

}