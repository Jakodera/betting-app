import 'package:flutter/cupertino.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/services/firestore_crud.dart';

class TicketValidationProvider extends ChangeNotifier {
  List<OddModel> _finishedMatches = [];
  List<List<OddModel>> _ticketMatches = [];
  List<String> _ticketIds = [];
  List<String> _ticketsForCashOutId = [];

  List<OddModel> get finishedMatches => _finishedMatches;
  List<List<OddModel>> get ticketMatches => _ticketMatches;
  List<String> get ticketIds => _ticketIds;
  List<String> get ticketsForCashOutId => _ticketsForCashOutId;

  set finishedMatches(List<OddModel> model) {
    _finishedMatches = model;
    notifyListeners();
  }

  set ticketMatches(List<List<OddModel>> model) {
    _ticketMatches = model;
    notifyListeners();
  }

  set ticketIds(List<String> value) {
    _ticketIds = value;
    notifyListeners();
  }

  set ticketsForCashOutId(List<String> value) {
    _ticketsForCashOutId = value;
    notifyListeners();
  }

  addMatch(OddModel model) {
    _finishedMatches.add(model);
    notifyListeners();
  }

  //Function should take care of validation part for ticket
  validateMatchResult(List<OddModel> realTip, List<List<OddModel>> ticketTip,
      FirebaseCrud fbCrud, List<String> ticketId, PlayerModel model) async {
    int totalbets = model.totalBets ?? 0;
    int totalTicketsWon = model.ticketsWon ?? 0;
    int totalTicketsLost = model.ticketsLost ?? 0;
    int totalActiveTickets = totalbets - (totalTicketsLost + totalTicketsWon) ?? 0;

    for (var i = 0; i < ticketTip.length; i++) {
      int controlNumber = 0;
      for (var q = 0; q < realTip.length; q++) {
        for (var j = 0; j < ticketTip[i].length; j++) {
          if (realTip[q].host == ticketTip[i][j].host) {
            if (realTip[q].pick == ticketTip[i][j].pick) {
              controlNumber++;
              await fbCrud.updateMatchStatus(
                  ticketId[i], "win", ticketTip[i][j].id);
              if (controlNumber == ticketTip[i].length) {
                await fbCrud.updateTicket(ticketId[i], "win");
                totalTicketsWon++;
                totalActiveTickets--;

                var userData = Map<String, dynamic>();
                userData["ticketsWon"] = totalTicketsWon;
                userData["winRate"] =
                    ((totalTicketsWon / ((totalbets - totalActiveTickets) ?? 1)) * 100).round();
                        

                await fbCrud.updateUserProfile(userData);
              }
            } else {
              await fbCrud.updateMatchStatus(
                  ticketId[i], "lose", ticketTip[i][j].id);
              await fbCrud.updateTicket(ticketId[i], "lose");
              await fbCrud.updateTicketProcess(ticketId[i]);
              totalTicketsLost++;

              var userData = Map<String, dynamic>();
              userData["ticketsLost"] = totalTicketsLost;
              userData["winRate"] =
                  ((totalTicketsWon / (totalbets - totalActiveTickets)) * 100)
                      .toInt();

              await fbCrud.updateUserProfile(userData);
            }
          }
        }
      }
    }
  }
}
