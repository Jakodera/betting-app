import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/bet/bet_bloc.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/models/user_ticket.dart';
import 'package:fun_app/my_home_page.dart';
import 'package:fun_app/providers/list_tickets_stream.dart';
import 'package:fun_app/providers/profile_stream_provider.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';
import 'package:fun_app/providers/value_notifiers/ticket_filter_value_notifier.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  final String userId;
  final FirebaseUserAuth userAuth;

  const AuthWidgetBuilder({Key key, this.userId, this.userAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Boiler Plate Kod za Initial Data Stream Providera
    List<UserTicket> tickets = [];
    tickets.add(UserTicket.initialData());

    return MultiProvider(
      providers: [
        Provider<FirebaseCrud>(
          create: (_) => FirebaseCrud(uid: userId),
        ),
        StreamProvider<PlayerModel>(
          create: (_) => ProfileStreamProvider(userId).playerProfile(),
          initialData: PlayerModel.initialData(),
        ),
        StreamProvider<List<UserTicket>>(
          create: (_) => TicketListStream(userId).getTicket(),
          initialData: tickets,
        ),
        ChangeNotifierProvider<TicketValidationProvider>(
          create: (_) => TicketValidationProvider(),
        ),
        ChangeNotifierProvider<TicketFilterValue>(
          create: (_) => TicketFilterValue(),
        ),
      ],
      child: BlocProvider(
        create: (context) => BetBloc(firebaseCrud: FirebaseCrud(uid: userId)),
        child: MyHomePageParent(userAuth: userAuth,)),
    );
  }
}
