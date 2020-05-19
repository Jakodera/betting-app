import 'package:flutter/material.dart';
import 'package:fun_app/models/leagues_avatar_model.dart';
import 'package:fun_app/providers/value_notifiers/league_selected_value_notifier.dart';
import 'package:provider/provider.dart';

class DisplayLeagues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          return buildLeagues(context, index);
        },
      ),
    );
  }

  Widget buildLeagues(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Consumer<LeagueLogoSelected>(
        builder: (_, leagueIndex, __) => InkWell(
          onTap: () {
            leagueIndex.index = index;
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(leagues[index].imgPath),
            radius: 25,
          ),
        ),
      ),
    );
  }
}
