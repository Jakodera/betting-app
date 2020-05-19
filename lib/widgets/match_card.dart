import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatelessWidget {
  final OddModel game;

  MatchCard({this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Stack(
          children: <Widget>[
            (game.minute.length < 4 && game.minute != "FT")
                ? Positioned(
                    top: 6,
                    right: 4,
                    child: _liveLockedWidget(),
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _tournamentName(),
                _cardDate(),
                _cardTime(),
                SizedBox(height: 8),
                _cardImages(),
                _cardScore(),
                SizedBox(height: 4),
                (game.minute == "FT")
                    ? _displayFinishedMatches()
                    : Consumer<BetProvider>(
                        builder: (_, betProvider, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _displayHomeTeam(betProvider),
                            _displayDrawTeam(betProvider),
                            _displayAwayTeam(betProvider),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _tournamentName() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 5),
      child: Text(
        game.tournamentName,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  _cardDate() {
    return Text(
      game.date,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }

  _cardTime() {
    return Text(
      game.minute,
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  _cardImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.network(
            game.homeImage,
            height: 48,
            width: 48,
          ),
          Image.network(
            game.awayImage,
            height: 48,
            width: 48,
          ),
        ],
      ),
    );
  }

  _cardScore() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            game.score == "v" ? game.homeAbb : game.score[0],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Text(
            ":",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            game.score == "v" ? game.awayAbb : game.score[4],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  _displayFinishedMatches() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _displayFinishedCard(game.host, game.coefHost, "1", game),
        _displayFinishedCard("Draw", game.coefDraw, "X", game),
        _displayFinishedCard(game.guest, game.coefGuest, "2", game),
      ],
    );
  }

  _userTip(BetProvider betProvider, String tip) {
    if (game.minute.length < 4 && game.minute != "FT") {
      return;
    } else {
      int ind = betProvider.oddModel.indexOf(game);
      if (ind > -1) {
        if (betProvider.oddModel[ind].pick == tip) {
          betProvider.removeMatch(game);
        } else {
          betProvider.removeMatch(game);
          game.pick = tip;
          betProvider.addMatch(game);
        }
      } else {
        game.pick = tip;
        betProvider.addMatch(game);
      }
    }
  }

  _displayHomeTeam(BetProvider betProvider) {
    return GestureDetector(
      onTap: () {
        _userTip(betProvider, "1");
      },
      child: _displayTeam(
        betProvider.oddModel,
        "1",
      ),
    );
  }

  _displayDrawTeam(BetProvider betProvider) {
    return GestureDetector(
      onTap: () {
        _userTip(betProvider, "X");
      },
      child: _displayTeam(
        betProvider.oddModel,
        "X",
      ),
    );
  }

  _displayAwayTeam(BetProvider betProvider) {
    return GestureDetector(
      onTap: () {
        _userTip(betProvider, "2");
      },
      child: _displayTeam(
        betProvider.oddModel,
        "2",
      ),
    );
  }

  _displayFinishedCard(String team, String odd, String pick, OddModel model) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          height: 26,
          width: 54,
          child: Text(
            team,
            maxLines:
                (team.contains(" ") && team.length >= 10 && team.length < 22)
                    ? 2
                    : 1,
            style: TextStyle(color: Colors.white, fontSize: 10),
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 8),
          height: 28,
          width: 46,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.8),
            color: pick == model.pick ? Colors.blueGrey : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              odd,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  _displayTeam(List<OddModel> model, String pickara) {
    String team, odd;
    switch (pickara) {
      case "1":
        team = game.host;
        odd = game.coefHost;
        break;
      case "X":
        team = "Draw";
        odd = game.coefDraw;
        break;
      case "2":
        team = game.guest;
        odd = game.coefGuest;
        break;
    }

    OddModel currGame =
        (model.indexOf(game) > -1) ? model[model.indexOf(game)] : null;
    bool modelPick;

    if (game.minute.length < 4 && game.minute != "FT") {
      modelPick = false;
    } else if (model.contains(game) && currGame.pick == pickara) {
      modelPick = true;
    } else {
      modelPick = false;
    }

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          height: 26,
          width: 54,
          child: Text(
            team,
            maxLines:
                (team.contains(" ") && team.length >= 10 && team.length < 22)
                    ? 2
                    : 1,
            style: TextStyle(color: Colors.white, fontSize: 10),
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 8),
          height: 28,
          width: 46,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.8),
            color: modelPick ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              odd,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _liveLockedWidget() {
    return Row(
      children: <Widget>[
        Text(
          "LIVE",
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(width: 6),
        Icon(
          Icons.lock,
          size: 16,
          color: Colors.grey,
        ),
      ],
    );
  }
}
