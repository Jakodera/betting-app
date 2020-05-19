import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/bet/bet_bloc.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:fun_app/services/dialogs/bet_placed_dialog.dart';
import 'package:fun_app/widgets/ticket_builder.dart';
import 'package:provider/provider.dart';

class BettingTipsPage extends StatefulWidget {
  @override
  _BettingTipsPageState createState() => _BettingTipsPageState();
}

class _BettingTipsPageState extends State<BettingTipsPage>
    with AutomaticKeepAliveClientMixin {
  UserTicket _userTicket;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _userTicket = UserTicket();

    final betProvider = Provider.of<BetProvider>(context);
    final _profileStream = Provider.of<PlayerModel>(context, listen: false);

    Widget column = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 58.0 * betProvider.oddModel.length + 34,
            width: MediaQuery.of(context).size.width * 0.95,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: betProvider.oddModel.length,
              itemBuilder: (context, index) {
                return TicketBuilder(
                  model: betProvider.oddModel[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                betProvider.oddModel.length == 1
                    ? Text(
                        "1 tip",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    : Text(
                        "${betProvider.oddModel.length} tips",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                Text(
                  "Odd:  ${betProvider.resultOdd.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 0.55,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "CashOut: ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "${betProvider.cashOut.toStringAsFixed(2)} €",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 14),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          betProvider.payOut(0, 0);
                          betProvider.betInput = 0;
                        } else {
                          betProvider.addInput(int.parse(value));
                          betProvider.payOut(betProvider.resultOdd,
                              betProvider.betInput.toDouble());
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.euro_symbol,
                    color: Colors.white,
                    size: 14,
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: showSubmitBetButton(betProvider, _profileStream) == true
                ? Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.85),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.white30, width: 0.5)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "PLACE A BET",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        _errorInfo("Please check this:"),
                        SizedBox(height: 4),
                        _errorInfo("Max CashOut: 300,000 €"),
                        SizedBox(height: 4),
                        _errorInfo("Max Bet: 10,000 €"),
                        SizedBox(height: 4),
                        _errorInfo("Max Tips: 10"),
                        SizedBox(height: 4),
                        _errorInfo("Don't have enough funds?")
                      ],
                    ),
                  ),
            onTap: () async {
              // All Logic happens here ---> Maybe to complex
              BlocProvider.of<BetBloc>(context).add(
                BetPlacedButtonClicked(
                  _userTicket.toMap(
                      betProvider.resultOdd.toStringAsFixed(2),
                      betProvider.cashOut.toStringAsFixed(2),
                      betProvider.betInput,
                      betProvider.oddModel.length,
                      _profileStream.totalBets + 1),
                  _profileStream.toMap(
                    _profileStream.availableFunds,
                    betProvider.betInput,
                    _profileStream.totalBets,
                    ((double.parse(_profileStream.totalOdd) +
                                betProvider.resultOdd) /
                            (_profileStream.totalBets + 1))
                        .toStringAsFixed(1),
                    ((double.parse(_profileStream.totalStake) +
                                betProvider.betInput) /
                            (_profileStream.totalBets + 1))
                        .toStringAsFixed(1),
                    (double.parse(_profileStream.moneyLost) +
                            betProvider.betInput)
                        .toStringAsFixed(1),
                    (double.parse(_profileStream.totalOdd) +
                            betProvider.resultOdd)
                        .toStringAsFixed(1),
                    (double.parse(_profileStream.totalStake) +
                            betProvider.betInput)
                        .toStringAsFixed(1),
                  ),
                  betProvider.oddModel,
                ),
              );
            },
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(top: 78.0, bottom: 40, right: 20, left: 20),
        child: betProvider.oddModel.length == 0
            ? Container()
            : BlocConsumer(
                bloc: BlocProvider.of<BetBloc>(context),
                listener: (context, state) {
                  if (state is BetError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
                          "Ooops ... Error Ocurred!",
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else if (state is BetLoading) {
                    showDialog(
                      context: context,
                      child: BetPlacedDialog(
                        isLoading: true,
                      ),
                    );
                  } else if (state is BetLoaded) {
                    showDialog(
                      context: context,
                      child: BetPlacedDialog(
                        isLoading: false,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BetInitial) {
                    return column;
                  } else if (state is BetLoaded) {
                    return Container();
                  }
                  return SizedBox();
                },
              ),
      ),
    );
  }

  bool showSubmitBetButton(BetProvider betProvider, PlayerModel model) {
    if (betProvider.betInput > 10000) {
      return false;
    } else if (betProvider.cashOut > 300000) {
      return false;
    } else if (betProvider.oddModel.length > 10) {
      return false;
    } else if (betProvider.betInput > double.parse(model.availableFunds)) {
      return false;
    }
    return true;
  }

  Text _errorInfo(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 13, color: Colors.white),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
