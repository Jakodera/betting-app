import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fun_app/models/leagues_avatar_model.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/value_notifiers/league_selected_value_notifier.dart';
import 'package:fun_app/services/firebase_rtdb.dart';
import 'package:provider/provider.dart';

import 'match_card.dart';

class DisplayMatchCard extends StatefulWidget {
  @override
  _DisplayMatchCardState createState() => _DisplayMatchCardState();
}

class _DisplayMatchCardState extends State<DisplayMatchCard> {
  List<OddModel> models = [];
  List<OddModel> games = [];
  StreamSubscription _onDataAdded;
  StreamSubscription _onDataChanged;

  @override
  void initState() {
    //final fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    //fbCrud.updateMatchStatus("hSKeAeZlJq3FakUdcXYU", "win", 0);
    FirebaseRTDB.onMatchAdded(_onEntryAdded)
        .then((value) => _onDataAdded = value);
    FirebaseRTDB.onMatchChanged(_onEntryChanged)
        .then((value) => _onDataChanged = value);
    super.initState();
  }

  @override
  void dispose() {
    _onDataAdded.cancel();
    _onDataChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<LeagueLogoSelected>(context);
    games = models
        .where(
            (match) => match.tournamentName == leagues[index.index].searchName)
        .toList();
    games.sort((a, b) => a.minute.compareTo(b.minute));
    return Container(
      height: MediaQuery.of(context).size.height / 2.70,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: games.length > 0
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return MatchCard(
                    oddMatches: games,
                    index: index,
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: Consumer<LeagueLogoSelected>(
                      builder: (_, leagueLogo, __) => Text(
                        "No ${leagues[leagueLogo.index].searchName} matches today!",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      models.add(OddModel.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var old = models.singleWhere((model) => model.key == event.snapshot.key);
    setState(() {
      models[models.indexOf(old)] = OddModel.fromSnapshot(event.snapshot);
    });
  }
}
