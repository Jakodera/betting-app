

class PlayerModel {
  String uid;
  String username;
  String userAvatar;
  String availableFunds;
  int totalBets;
  String profits;
  int winRate;
  String form;
  String biggestWin;
  String averageStake;
  String averageOdd;
  String moneyLost;

  PlayerModel(
      {this.availableFunds,
      this.averageOdd,
      this.averageStake,
      this.biggestWin,
      this.form,
      this.moneyLost,
      this.profits,
      this.totalBets,
      this.uid,
      this.userAvatar,
      this.username,
      this.winRate});

  PlayerModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    username = map["username"];
    userAvatar = map["userAvatar"];
    availableFunds = map["availableFunds"];
    totalBets = map["totalBets"];
    profits = map["profits"];
    winRate = map["winRate"];
    form = map["form"];
    biggestWin = map["biggestWin"];
    averageStake = map["averageStake"];
    averageOdd = map["averageOdd"];
    moneyLost = map["moneyLost"];
  }

  factory PlayerModel.initialData() {
    return PlayerModel(
      username: "",
      userAvatar: "",
      availableFunds: "0.0",
      totalBets: 0,
      profits: "0.0",
      winRate: 0,
      form: "0.0",
      biggestWin: "0.0",
      averageStake: "0.0",
      averageOdd: "0.0",
      moneyLost: "0.0",
    );
  }

  Map<String, dynamic> toMap(String funds, int bet, int totalbets, String summedOdd, String summedStake,
                String moneyLostSoFar, int userWinRate) {
    return {
      "availableFunds": (double.parse(funds) - bet).toStringAsFixed(1),
      "totalBets": totalbets + 1,
      "averageOdd": summedOdd,
      "averageStake": summedStake,
      "moneyLost": (double.parse(moneyLostSoFar) + bet).toStringAsFixed(1),
      "form": (userWinRate / 20).toStringAsFixed(1)
    };
  }
}
