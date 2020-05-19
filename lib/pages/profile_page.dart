import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fun_app/models/player_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final profileStream = Provider.of<PlayerModel>(context);

    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                profileStream.username,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 12,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: profileStream.userAvatar == ""
                    ? AssetImage("assets/images/milan.png")
                    : NetworkImage(profileStream.userAvatar),
                backgroundColor: Colors.black12,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: screenHeight * 0.1,
                width: screenWidth * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${profileStream.availableFunds} €",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Text(
                      "Available Funds",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildThreeColums("${profileStream.totalBets}", "Total Bets",
                        Colors.white),
                    buildThreeColums(
                        "${profileStream.profits}€", "Profits", Colors.green),
                    buildThreeColums(
                        "${profileStream.winRate}%", "Win Rate", Colors.grey),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              RatingBar(
                initialRating: profileStream.winRate.toDouble() / 10,
                ignoreGestures: true,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 5),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        buildCenterColumn(
                            "${profileStream.biggestWin}", "Biggest Win"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenWidth * 0.35,
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildCenterColumn(
                            "${profileStream.averageOdd}", "Average Odd")
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.13,
                      color: Colors.grey,
                      width: 1,
                    ),
                    Column(
                      children: <Widget>[
                        buildCenterColumn(
                            "${profileStream.averageStake}", "Average Stake"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenWidth * 0.38,
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildCenterColumn(
                            "${profileStream.moneyLost}", "Money Lost")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
              ),
              Spacer(),
              Container(
                height: screenHeight * 0.15,
                width: screenWidth * 0.94,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThreeColums(String title, String subTitle, Color color) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 20, color: color),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          subTitle,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildCenterColumn(String title, String subTitle) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: subTitle == "Money Lost" ? Colors.red : Colors.white),
        ),
        Text(
          subTitle,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
