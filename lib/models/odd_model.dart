import 'package:firebase_database/firebase_database.dart';

class OddModel {
  String id;
  String key;
  String guest;
  String coefGuest;
  String coefDraw;
  String coefHost;
  String host;
  String draw;
  String minute;
  String tournamentName;
  String date;
  String score;
  String pick;
  String homeImage;
  String homeAbb;
  String awayImage;
  String awayAbb;
  String odd;
  String status;

  OddModel(
      {this.awayAbb,
      this.id,
      this.awayImage,
      this.coefDraw,
      this.coefGuest,
      this.coefHost,
      this.date,
      this.draw,
      this.guest,
      this.homeAbb,
      this.homeImage,
      this.host,
      this.key,
      this.minute,
      this.pick,
      this.score,
      this.tournamentName,
      this.status,
      this.odd});

  OddModel.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    guest = snapshot.value["awayTeam"];
    coefGuest = snapshot.value["awayOdd"];
    coefDraw = snapshot.value["drawOdd"];
    coefHost = snapshot.value["homeOdd"];
    host = snapshot.value["homeTeam"];
    draw = snapshot.value["drawTeam"];
    minute = snapshot.value["minute"];
    tournamentName = snapshot.value["tournamentName"];
    date = snapshot.value["date"];
    score = snapshot.value["score"];
    pick = snapshot.value["pick"];
    homeImage = snapshot.value["homeImage"];
    awayImage = snapshot.value["awayImage"];
    awayAbb = snapshot.value["awayAbb"];
    homeAbb = snapshot.value["homeAbb"];
  }

  OddModel.fromDbJson(Map<dynamic, dynamic> map) {
    host = map["homeTeam"];
    pick = map["pick"];
  }

  OddModel.fromJson(Map<dynamic, dynamic> mapa, String matchId)
      : guest = mapa["guest"],
        host = mapa["host"],
        minute = mapa["time"],
        tournamentName = mapa["league"],
        date = mapa["date"],
        pick = mapa["pick"],
        odd = mapa["odd"],
        id = matchId,
        status = mapa["status"];

  OddModel.initialData() {
    guest = "";
    host = "";
    minute = "";
    tournamentName = "";
    date = "";
    pick = "";
    odd = "";
    status = "";
  }

  String findOdd(OddModel model) {
    if (model.pick == "1") return model.coefHost;
    if (model.pick == "X") return model.coefDraw;
    if (model.pick == "2")
      return model.coefGuest;
    else
      return "No data";
  }

  Map<String, dynamic> oddModelToMap(OddModel model) {
    return {
      "time": model.minute,
      "date": model.date,
      "host": model.host,
      "guest": model.guest,
      "pick": model.pick,
      "odd": findOdd(model),
      "league": model.tournamentName,
      "status": ""
    };
  }

  /*
  Map<String, dynamic> listOddModelToMap(List<OddModel> models) {
      return {
        "games": models.map((model) {
        return model.oddModelToMap();
      }).toList(),
      };
  }
  */
}
