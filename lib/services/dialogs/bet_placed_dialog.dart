import 'package:flutter/material.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:provider/provider.dart';

class BetPlacedDialog extends StatefulWidget {
  final String buttonRoute;
  final String docRef;

  const BetPlacedDialog({Key key, this.buttonRoute, this.docRef})
      : super(key: key);

  @override
  _BetPlacedDialogState createState() => _BetPlacedDialogState();
}

class _BetPlacedDialogState extends State<BetPlacedDialog> {
  double averageOdd, averageStake;
  PlayerModel _model;
  String funds, moneyLostSoFar;
  int totalBets, userWinRate;

  @override
  void initState() {
    var fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    var playerProfile = Provider.of<PlayerModel>(context, listen: false);
    fbCrud.getSummedOdd().then((value) {
      averageOdd = value;
    });
    fbCrud.getSummedStake().then((value) {
      averageStake = value;
    });
    funds = playerProfile.availableFunds;
    totalBets = playerProfile.totalBets;
    moneyLostSoFar = playerProfile.moneyLost;
    userWinRate = playerProfile.winRate;
    _model = PlayerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var betprovider = Provider.of<BetProvider>(context, listen: false);
    var selectedPage = Provider.of<SelectedPage>(context, listen: false);
    var fbCrud = Provider.of<FirebaseCrud>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 5,
                          style: BorderStyle.solid,
                          color: Colors.green),
                    ),
                    child: Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bet Placed",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                      onPressed: () {
                        fbCrud.updateUserProfile(_model.toMap(
                            funds,
                            betprovider.betInput,
                            totalBets,
                            averageOdd.toStringAsFixed(1),
                            averageStake.toStringAsFixed(1),
                            moneyLostSoFar,
                            userWinRate));
                        betprovider.oddModel.clear();
                        betprovider.resultOdd = 1.0;
                        betprovider.cashOut = 0.0;
                        selectedPage.selectedPage = 0;
                        Navigator.pushReplacementNamed(
                            context, widget.buttonRoute);
                      },
                      child: Container(
                        width: 200,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.2),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Press here to continue",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
