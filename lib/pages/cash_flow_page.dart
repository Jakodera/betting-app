import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/providers/value_notifiers/ticket_filter_value_notifier.dart';
import 'package:fun_app/widgets/ticket_display.dart';
import 'package:provider/provider.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:fun_app/services/firebase_rtdb.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';

class CashFlowPage extends StatefulWidget {
  @override
  _CashFlowPageState createState() => _CashFlowPageState();
}

class _CashFlowPageState extends State<CashFlowPage>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  FirebaseCrud _fbCrud;
  PlayerModel _playerProfile;
  TicketValidationProvider _validationProvider;

  @override
  void initState() {
    // Refresh Key
    refreshKey = GlobalKey<RefreshIndicatorState>();
    //podaci o iogracu sa firebasea
    _playerProfile = Provider.of<PlayerModel>(context, listen: false);
    _validationProvider =
        Provider.of<TicketValidationProvider>(context, listen: false);
    _fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    // Validiraj odmah cim korisnik pristupi stranici
    FirebaseRTDB.matchStatusQuery(_validationProvider);
    _validationProvider.validateMatchResult(
        _validationProvider.finishedMatches,
        _validationProvider.ticketMatches,
        _fbCrud,
        _validationProvider.ticketIds,
        _playerProfile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Screen Height and Width
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    //Lista filtriranih tiketa sa firebasea
    var filterTicket = Provider.of<TicketFilterValue>(context);
    var ticketStream = Provider.of<List<UserTicket>>(context)
        .where((ticket) => ticket.ticketStatus == filterTicket.filterTickets)
        .toList();
    // Stream Matcheva sa ticketa
    List<OddModel> models = [];
    models.add(OddModel.initialData());

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
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ).toList(),
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
                  // Get results from RealTime Database
                  await FirebaseRTDB.matchStatusQuery(_validationProvider);
                  // Validate all tickets
                  await _validationProvider.validateMatchResult(
                      _validationProvider.finishedMatches,
                      _validationProvider.ticketMatches,
                      _fbCrud,
                      _validationProvider.ticketIds,
                      _playerProfile);
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
