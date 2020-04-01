
import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:provider/provider.dart';

class TicketDisplay extends StatefulWidget {
  final UserTicket snap;

  const TicketDisplay({Key key, this.snap}) : super(key: key);

  @override
  _TicketDisplayState createState() => _TicketDisplayState();
}

class _TicketDisplayState extends State<TicketDisplay> {
  List<int> wonAndActiveTickets = [];

  @override
  void initState() {
    var fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    fbCrud.numberOfWinningOrActiveTickets().then((value) {
        wonAndActiveTickets = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    final userProfileStream = Provider.of<PlayerModel>(context, listen: false);

    return StreamBuilder<List<OddModel>>(
      stream: fbCrud.matches(widget.snap.id),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Container();
        return Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      style: BorderStyle.solid,
                      color: _properBorderColor(widget.snap.ticketStatus),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                              "Ticket Number: #" + widget.snap.ticketNum.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox()
                              ],
                            ),
                            Text("Tips: " + snapshot.data.length.toString(),
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Divider(
                        color: Colors.white,
                        thickness: 0.25,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(height: 2),
                      Container(
                        color: Colors.transparent,
                        height: snapshot.data.length.toDouble() * 50,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(snapshot.data[index].date,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                            Text(snapshot.data[index].minute,
                                                style:
                                                    TextStyle(color: Colors.white)),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(snapshot.data[index].host.length > 18 ? snapshot.data[index].host.substring(0, 18) : snapshot.data[index].host,
                                                style:
                                                    TextStyle(color: Colors.white)),
                                            Text(snapshot.data[index].guest,
                                                style:
                                                    TextStyle(color: Colors.white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(snapshot.data[index].pick,
                                            style: TextStyle(color: Colors.white)),
                                        SizedBox(width: 16),
                                        Text(snapshot.data[index].odd,
                                            style: TextStyle(color: Colors.white)),
                                        snapshot.data[index].status != ""
                                            ? Row(
                                                children: <Widget>[
                                                  SizedBox(width: 12),
                                                  _getProperIcon(
                                                      snapshot.data[index].status)
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      Divider(
                        color: Colors.white,
                        thickness: 0.25,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Odd:",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              Text("Stake:",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              Text("Payout:",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(widget.snap.resultOdd,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              Text(widget.snap.bet.toString() + " €",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              Text(widget.snap.cashout + " €",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      (widget.snap.ticketStatus == "win" && widget.snap.processFinished == "no")
                          ? _setupCashOut(context, fbCrud, userProfileStream, widget.snap.id)
                          : Container()
                    ],
                  ),
                ),
              );
      }
    );
  }

  Color _properBorderColor(String value) {
    if(value == "win") return Colors.green;
    if(value == "lose") return Colors.red;
    return Colors.white;
  }

  _getProperIcon(String value) {
    if (value == "win")
      return Icon(
        Icons.check,
        color: Colors.green,
      );
    if (value == "lose")
      return Icon(
        Icons.close,
        color: Colors.red,
      );
  }

  _setupCashOut(BuildContext context, FirebaseCrud fbCrud, PlayerModel userProfile, String ticketId) {
    var userData = Map<String, dynamic>();
    String currFunds = userProfile.availableFunds;
    String currProfits = userProfile.profits;
    String currBiggestWin = userProfile.biggestWin;

    userData["availableFunds"] = (double.parse(currFunds) + double.parse(widget.snap.cashout)).toStringAsFixed(1);
    userData["profits"] = (double.parse(currProfits) + double.parse(widget.snap.cashout)).toStringAsFixed(1);
    if(double.parse(widget.snap.cashout) > double.parse(currBiggestWin)) {
      userData["biggestWin"] = double.parse(widget.snap.cashout).toStringAsFixed(1);
    }

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            await fbCrud.updateUserProfile(userData);
            await fbCrud.updateTicketProcess(ticketId);
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.green,
            child: Align(
              alignment: Alignment.center,
                        child: Text(
                "Cashout", style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
