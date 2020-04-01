import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:fun_app/providers/list_tickets_stream.dart';
import 'package:fun_app/providers/profile_stream_provider.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';
import 'package:fun_app/providers/value_notifiers/league_selected_value_notifier.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';
import 'package:fun_app/providers/value_notifiers/ticket_filter_value_notifier.dart';
import 'package:fun_app/services/auth/auth.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<String>) builder;
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);

  Future<String> getDocReference(String uid) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .getDocuments();
    String docRef = querySnapshot.documents[0].documentID;
    return docRef;
  }

  @override
  Widget build(BuildContext context) {
    print("AuthWidgetBuilder built");
    BaseAuth auth = Provider.of<BaseAuth>(context, listen: false);
    String docId;
    List<UserTicket> tickets = [];
    tickets.add(UserTicket.initialData());

    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          getDocReference(snapshot.data).then((value) {
            docId = value;
          });
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<BetProvider>(
                create: (_) => BetProvider(),
              ),
              Provider<FirebaseCrud>(
                create: (_) => FirebaseCrud(snapshot.data, docId),
              ),
              ChangeNotifierProvider<SelectedPage>(
                create: (_) => SelectedPage(),
              ),
              ChangeNotifierProvider<LeagueLogoSelected>(
                create: (_) => LeagueLogoSelected(),
              ),
              StreamProvider<PlayerModel>(
                create: (_) => ProfileStreamProvider(docId).playerProfile(),
                initialData: PlayerModel.initialData(),
              ),
              StreamProvider<List<UserTicket>>(
                create: (_) => TicketListStream(docId).getTicket(),
                initialData: tickets,
              ),
              ChangeNotifierProvider<TicketValidationProvider>(
                create: (_) => TicketValidationProvider(),
              ),
              ChangeNotifierProvider<TicketFilterValue>(
                create: (_) => TicketFilterValue(),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
