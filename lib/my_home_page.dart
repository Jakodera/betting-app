import 'package:flutter/material.dart';

import 'package:fun_app/pages/betting_tips_page.dart';
import 'package:fun_app/pages/cash_flow_page.dart';
import 'package:fun_app/pages/pick_of_the_day_page.dart';
import 'package:fun_app/pages/profile_page.dart';
import 'package:fun_app/providers/value_notifiers/my_home_page_value_notifier.dart';

import 'package:fun_app/services/auth/auth.dart';

import 'package:fun_app/widgets/app_background.dart';
import 'package:fun_app/widgets/display_tab_bar.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final List<Widget> pages = [
    PickOfTheDay(),
    BettingTipsPage(),
    CashFlowPage(),
    ProfilePage(),
  ];

  void _signOut(BuildContext context) async {
    try {
      var auth = Provider.of<BaseAuth>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Home Page built");
    final selectedPage = Provider.of<SelectedPage>(context, listen: false);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        AppBackground(),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.055,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Consumer<SelectedPage>(
                  builder: (_, currentPage, __) =>
                      DisplayTabBar(index: currentPage.selectedPage))),
        ),
        PageView.builder(
          pageSnapping: true,
          itemBuilder: (context, index) {
            return pages[index];
          },
          onPageChanged: (int index) => selectedPage.selectedPage = index,
          itemCount: pages.length,
        ),
        //RaisedButton(
          //child: Text("Logout"),
          //onPressed: () => _signOut(context),
        //),
      ],
    ));
  }
}
