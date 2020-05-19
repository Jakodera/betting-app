import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_app/blocs/logout/logout_bloc.dart';
import 'package:fun_app/blocs/logout/logout_event.dart';
import 'package:fun_app/blocs/logout/logout_state.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:fun_app/pages/betting_tips_page.dart';
import 'package:fun_app/pages/cash_flow_page.dart';
import 'package:fun_app/pages/pick_of_the_day_page.dart';
import 'package:fun_app/pages/profile_page.dart';
import 'package:fun_app/providers/ticket_validation_provider.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';
import 'package:fun_app/services/auth/login_page.dart';
import 'package:fun_app/services/firestore_crud.dart';
import 'package:fun_app/services/repositories/user_auth_repository.dart';
import 'package:fun_app/widgets/app_background.dart';
import 'package:fun_app/widgets/display_tab_bar.dart';
import 'package:provider/provider.dart';

class MyHomePageParent extends StatelessWidget {
  final FirebaseUserAuth userAuth;

  MyHomePageParent({@required this.userAuth});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutBloc(userAuth: userAuth),
      child: MyHomePage(
        userAuth: userAuth,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseUserAuth userAuth;

  MyHomePage({@required this.userAuth});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = [
    PickOfTheDay(),
    BettingTipsPage(),
    CashFlowPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    final ticketProvider =
        Provider.of<TicketValidationProvider>(context, listen: false);
    final fbCrud = Provider.of<FirebaseCrud>(context, listen: false);
    fbCrud.userTips(ticketProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPage = Provider.of<SelectedPage>(context, listen: false);
    final playerProfile = Provider.of<PlayerModel>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBackground(),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.084,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Consumer<SelectedPage>(
                builder: (_, currentPage, __) =>
                    DisplayTabBar(index: currentPage.selectedPage),
              ),
            ),
          ),
          BlocConsumer(
            bloc: BlocProvider.of<LogoutBloc>(context),
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPageParent(
                      userAuth: widget.userAuth,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LogoutInitial) {
                return Container();
              } else if (state is LogoutSuccess) {
                return Container();
              } else if (state is LogoutError) {
                print("Logout failed");
              }
              return Container();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: PageView.builder(
              pageSnapping: true,
              itemBuilder: (context, index) {
                return pages[index];
              },
              onPageChanged: (int index) => selectedPage.selectedPage = index,
              itemCount: pages.length,
            ),
          ),
          Positioned(
            top: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Balance: ${playerProfile.availableFunds}",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 9,
                        backgroundImage: playerProfile.userAvatar == ""
                            ? AssetImage("assets/images/milan.png")
                            : NetworkImage(playerProfile.userAvatar),
                        backgroundColor: Colors.black12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        playerProfile.username, style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white24, fontSize: 11),
                    ),
                    color: Colors.transparent,
                    onPressed: () => BlocProvider.of<LogoutBloc>(context).add(
                      LogoutButtonPressed(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
