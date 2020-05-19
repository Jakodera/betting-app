
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

  factory OddModel.fromSnapshot(Map<dynamic, dynamic> json, String key) {
    return OddModel(
      key: key,
      guest: json["awayTeam"],
      coefGuest: json["awayOdd"],
      coefDraw: json["drawOdd"],
      coefHost: json["homeOdd"],
      host: json["homeTeam"],
      draw: json["drawTeam"],
      minute: json["minute"],
      tournamentName: json["tournamentName"],
      date: json["date"],
      score: json["score"],
      pick: json["pick"],
      homeImage: json["homeImage"],
      awayImage: json["awayImage"],
      awayAbb: json["awayAbb"],
      homeAbb: json["homeAbb"],
    );
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
      "status": "active"
    };
  }

  @override
  bool operator ==(o) => o is OddModel && key == o.key;
  
  @override
  int get hashCode => key.hashCode;

}
