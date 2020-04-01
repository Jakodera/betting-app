import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fun_app/widgets/display_league.dart';
import 'package:fun_app/widgets/display_match_card.dart';
import 'package:url_launcher/url_launcher.dart';

const String testDevice = "D4DB6B6720896A5839E352C73CEE6BF1";

class PickOfTheDay extends StatefulWidget {
  @override
  _PickOfTheDayState createState() => _PickOfTheDayState();
}

class _PickOfTheDayState extends State<PickOfTheDay>
    with AutomaticKeepAliveClientMixin {
  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;

  @override
  void initState() {
    /*
  targetingInfo = MobileAdTargetingInfo(
      keywords: <String>["soccer", "football", "betting", "prize"],
      testDevices: testDevice != null ? <String>[testDevice] : null,
      nonPersonalizedAds: true,
    );


  myBanner = BannerAd(
        adUnitId: "ca-app-pub-2076054945841795/7921732527",
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd is $event");
        });

  myBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);
  */
  super.initState();
  }
/*
  @override
  void dispose() { 
    myBanner.dispose();
    super.dispose();
  }
*/
  Widget build(BuildContext context) {
    super.build(context);

    print("Pick of the day build");
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: height * 0.12),
            GestureDetector(
              onTap: _launchURL,
              child: ClipRRect(
                child: Image.asset(
                  "assets/guess.jpg",
                  height: height * 0.2,
                  width: width * 0.95,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DisplayLeagues(),
            SizedBox(
              height: 10,
            ),
            DisplayMatchCard(),
            Spacer(),
            Container(
              height: height * 0.15,
              width: width * 0.94,
            )
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.fernwald.palyer_guessing_app';
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
