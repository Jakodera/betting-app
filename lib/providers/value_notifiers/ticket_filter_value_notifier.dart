import 'package:flutter/material.dart';

class TicketFilterValue with ChangeNotifier {

  String _filterTickets;

  TicketFilterValue() {
    _filterTickets = "active";
  }

  String get filterTickets => _filterTickets;

  void setFilterTickets(String value) {
    _filterTickets = value;
    notifyListeners();
  }

}