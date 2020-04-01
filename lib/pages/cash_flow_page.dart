import 'package:flutter/material.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';
import 'package:fun_app/providers/value_notifiers/ticket_filter_value_notifier.dart';
import 'package:fun_app/services/firebase_rtdb.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:fun_app/widgets/ticket_display.dart';
import 'package:provider/provider.dart';

class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    final provider =
        Provider.of<TicketValidationProvider>(context, listen: false);
    final fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    final playerModel = Provider.of<PlayerModel>(context, listen: false);
    FirebaseRTDB.matchStatusQuery(provider);
    fbCrud.userTips(provider);
    provider.validateMatchResult(provider.finishedMatches,
        provider.ticketMatches, fbCrud, provider.ticketIds, playerModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print("cash flow build");

    final filterTicket = Provider.of<TicketFilterValue>(context);
    var ticketStream = Provider.of<List<UserTicket>>(context)
        .where((ticket) => ticket.ticketStatus == filterTicket.filterTickets)
        .toList();
    final ticketValidation =
        Provider.of<TicketValidationProvider>(context, listen: false);
    final fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    final playerModel = Provider.of<PlayerModel>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.09),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Sort Out Tickets",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    focusColor: Colors.black,
                    value: filterTicket.filterTickets,
                    onChanged: (String value) {
                      filterTicket.setFilterTickets(value);
                    },
                    items: <String>["active", "win", "lose"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ));
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              height: height / 1.4,
              color: Colors.transparent,
              width: width - 32,
              child: RefreshIndicator(
                key: refreshKey,
                displacement: 20,
                onRefresh: () async {
                  await FirebaseRTDB.matchStatusQuery(ticketValidation);
                  await ticketValidation.validateMatchResult(
                      ticketValidation.finishedMatches,
                      ticketValidation.ticketMatches,
                      fbCrud,
                      ticketValidation.ticketIds,
                      playerModel);
                },
                child: ListView.builder(
                  itemCount: ticketStream.length,
                  itemBuilder: (context, index) {
                    return TicketDisplay(
                      snap: ticketStream[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
