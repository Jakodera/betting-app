import 'package:flutter/material.dart';
import 'package:fun_app/main.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:provider/provider.dart';

class BetPlacedDialog extends StatelessWidget {
  final bool isLoading;
  const BetPlacedDialog({Key key, this.isLoading = false}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final betProvider = Provider.of<BetProvider>(context, listen: false);
    final nextPage = Provider.of<SelectedPage>(context, listen: false);

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
              child: !isLoading ? _betCompletedColumn(betProvider, context, nextPage)
              : Image.asset("assets/images/loading2.gif"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _betCompletedColumn(BetProvider betProvider, BuildContext context, SelectedPage nextPage) {
    return Column(
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
                        betProvider.oddModel.clear();
                        betProvider.cashOut = 0.0;
                        betProvider.resultOdd = 1.0;
                        nextPage.selectedPage = 0;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyApp()
                        ));
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
              );
  }
}
