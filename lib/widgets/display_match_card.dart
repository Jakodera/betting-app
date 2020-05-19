import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fun_app/models/leagues_avatar_model.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/value_notifiers/league_selected_value_notifier.dart';
import 'package:provider/provider.dart';

import 'match_card.dart';

class DisplayMatchCard extends StatefulWidget {
  @override
  _DisplayMatchCardState createState() => _DisplayMatchCardState();
}

class _DisplayMatchCardState extends State<DisplayMatchCard> {
  List<OddModel> games = [];

  DatabaseReference _dbRef = FirebaseDatabase().reference().child("2020-03-07");

  @override
  Widget build(BuildContext context) {
    final selectedIndex = Provider.of<LeagueLogoSelected>(context);
    return StreamBuilder<Event>(
        stream: _dbRef.onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {

            List<OddModel> models = [];
            Map<dynamic, dynamic> data = snap.data.snapshot.value;
            data.forEach((key, value) {
              models.add(OddModel.fromSnapshot(value, key));
            });
            games = models
        .where((match) =>
            match.tournamentName == leagues[selectedIndex.index].searchName).toList();
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
                            game: games[index],
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          } else if (snap.hasError) {
            return Center(child: Text(snap.error));
          }
          return Center(child: Image.asset("assets/images/loading2.gif"),);
        });
  }

}
