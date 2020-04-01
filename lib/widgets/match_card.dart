import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatefulWidget {
  final List<OddModel> oddMatches;
  final int index;

  MatchCard({this.oddMatches, this.index});

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard>
    with AutomaticKeepAliveClientMixin {
  int ind;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("MatchCardBuild");
    return Container(
      width: 220,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Stack(
          children: <Widget>[
            (widget.oddMatches[widget.index].minute.length < 4 &&
                    widget.oddMatches[widget.index].minute != "FT")
                ? Positioned(
                    top: 6,
                    right: 4,
                    child: liveLockedWidget(),
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                Text(
                  widget.oddMatches[widget.index].tournamentName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      widget.oddMatches[widget.index].date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.oddMatches[widget.index].minute,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.network(
                        widget.oddMatches[widget.index].homeImage,
                        height: 48,
                        width: 48,
                      ),
                      Image.network(
                        widget.oddMatches[widget.index].awayImage,
                        height: 48,
                        width: 48,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        widget.oddMatches[widget.index].score == "v"
                            ? widget.oddMatches[widget.index].homeAbb
                            : widget.oddMatches[widget.index].score[0],
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
                        widget.oddMatches[widget.index].score == "v"
                            ? widget.oddMatches[widget.index].awayAbb
                            : widget.oddMatches[widget.index].score[4],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                (widget.oddMatches[widget.index].pick != "" &&
                        widget.oddMatches[widget.index].minute == "FT")
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          displayFinishedCard(
                              widget.oddMatches[widget.index].host,
                              widget.oddMatches[widget.index].coefHost,
                              "1",
                              widget.oddMatches[widget.index]),
                          displayFinishedCard(
                              "Draw",
                              widget.oddMatches[widget.index].coefDraw,
                              "X",
                              widget.oddMatches[widget.index]),
                          displayFinishedCard(
                              widget.oddMatches[widget.index].guest,
                              widget.oddMatches[widget.index].coefGuest,
                              "2",
                              widget.oddMatches[widget.index]),
                        ],
                      )
                    : Consumer<BetProvider>(
                        builder: (_, betProvider, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            (widget.oddMatches[widget.index].minute.length <
                                        4 &&
                                    widget.oddMatches[widget.index].minute !=
                                        "FT")
                                ? displayTeam(
                                    widget.oddMatches[widget.index].host,
                                    widget.oddMatches[widget.index].coefHost,
                                    betProvider.oddModel,
                                    widget.oddMatches[widget.index],
                                    "1",
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      ind = betProvider.oddModel.indexOf(
                                          widget.oddMatches[widget.index]);
                                      if (ind > -1) {
                                        if (betProvider.oddModel[ind].pick ==
                                            "1") {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);
                                        } else {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);

                                          widget.oddMatches[widget.index].pick =
                                              "1";
                                          betProvider.addMatch(
                                              widget.oddMatches[widget.index]);
                                        }
                                      } else {
                                        widget.oddMatches[widget.index].pick =
                                            "1";
                                        betProvider.addMatch(
                                            widget.oddMatches[widget.index]);
                                      }
                                    },
                                    child: displayTeam(
                                      widget.oddMatches[widget.index].host,
                                      widget.oddMatches[widget.index].coefHost,
                                      betProvider.oddModel,
                                      widget.oddMatches[widget.index],
                                      "1",
                                    )),
                            (widget.oddMatches[widget.index].minute.length <
                                        4 &&
                                    widget.oddMatches[widget.index].minute !=
                                        "FT")
                                ? displayTeam(
                                    "Draw",
                                    widget.oddMatches[widget.index].coefDraw,
                                    betProvider.oddModel,
                                    widget.oddMatches[widget.index],
                                    "X",
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      ind = betProvider.oddModel.indexOf(
                                          widget.oddMatches[widget.index]);
                                      if (ind > -1) {
                                        if (betProvider.oddModel[ind].pick ==
                                            "X") {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);
                                        } else {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);
                                          widget.oddMatches[widget.index].pick =
                                              "X";
                                          betProvider.addMatch(
                                              widget.oddMatches[widget.index]);
                                          betProvider.oddModel[ind].pick = "X";
                                        }
                                      } else {
                                        widget.oddMatches[widget.index].pick =
                                            "X";
                                        betProvider.addMatch(
                                            widget.oddMatches[widget.index]);
                                      }
                                    },
                                    child: displayTeam(
                                      "Draw",
                                      widget.oddMatches[widget.index].coefDraw,
                                      betProvider.oddModel,
                                      widget.oddMatches[widget.index],
                                      "X",
                                    ),
                                  ),
                            (widget.oddMatches[widget.index].minute.length <
                                        4 &&
                                    widget.oddMatches[widget.index].minute !=
                                        "FT")
                                ? displayTeam(
                                    widget.oddMatches[widget.index].guest,
                                    widget.oddMatches[widget.index].coefGuest,
                                    betProvider.oddModel,
                                    widget.oddMatches[widget.index],
                                    "2",
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      ind = betProvider.oddModel.indexOf(
                                          widget.oddMatches[widget.index]);
                                      if (ind > -1) {
                                        if (betProvider.oddModel[ind].pick ==
                                            "2") {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);
                                        } else {
                                          betProvider.removeMatch(
                                              widget.oddMatches[widget.index],
                                              ind);
                                          widget.oddMatches[widget.index].pick =
                                              "2";
                                          betProvider.addMatch(
                                              widget.oddMatches[widget.index]);
                                          betProvider.oddModel[ind].pick = "2";
                                        }
                                      } else {
                                        widget.oddMatches[widget.index].pick =
                                            "2";
                                        betProvider.addMatch(
                                            widget.oddMatches[widget.index]);
                                      }
                                    },
                                    child: displayTeam(
                                      widget.oddMatches[widget.index].guest,
                                      widget.oddMatches[widget.index].coefGuest,
                                      betProvider.oddModel,
                                      widget.oddMatches[widget.index],
                                      "2",
                                    ),
                                  ),
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

  Widget displayFinishedCard(
      String team, String odd, String pick, OddModel model) {
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

  Widget displayTeam(String team, String odd, List<OddModel> model,
      OddModel oddModel, String pickara) {
    bool modelPick = false;

    if (model.contains(oddModel) && oddModel.pick == pickara) modelPick = true;

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

  Widget liveLockedWidget() {
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

  @override
  bool get wantKeepAlive => true;
}
