class PlayerModel {
  String availableFunds;
  String averageOdd;
  String averageStake;
  String biggestWin;
  String form;
  String moneyLost;
  String profits;
  int ticketsLost;
  int ticketsWon;
  int totalBets;
  String totalOdd;
  String totalStake;
  String uid;
  String userAvatar;
  String username;
  int winRate;

  PlayerModel({
    this.availableFunds,
    this.averageOdd,
    this.averageStake,
    this.biggestWin,
    this.form,
    this.moneyLost,
    this.profits,
    this.ticketsLost,
    this.ticketsWon,
    this.totalBets,
    this.totalOdd,
    this.totalStake,
    this.uid,
    this.userAvatar,
    this.username,
    this.winRate,
  });

  PlayerModel.fromMap(Map<String, dynamic> map) {
    availableFunds = map["availableFunds"];
    averageOdd = map["averageOdd"];
    averageStake = map["averageStake"];
    biggestWin = map["biggestWin"];
    form = map["form"];
    moneyLost = map["moneyLost"];
    profits = map["profits"];
    ticketsLost = map["ticketsLost"];
    ticketsWon = map["ticketsWon"];
    totalBets = map["totalBets"];
    totalOdd = map["totalOdd"];
    totalStake = map["totalStake"];
    uid = map["uid"];
    userAvatar = map["userAvatar"];
    username = map["username"];
    winRate = map["winRate"];
  }

  factory PlayerModel.initialData() {
    return PlayerModel(
      username: "",
      userAvatar: "",
      availableFunds: "0.0",
      totalBets: 0,
      profits: "0.0",
      winRate: 0,
      form: "", // TODO LLWWL
      biggestWin: "0.0",
      averageStake: "0.0",
      averageOdd: "0.0",
      moneyLost: "0.0",
    );
  }

  Map<String, dynamic> toMap(
      String funds,
      int bet,
      int totalbets,
      String summedOdd,
      String summedStake,
      String moneyLostSoFar,
      String totalOdd,
      String totalStake) {
    return {
      "availableFunds": (double.parse(funds) - bet).toStringAsFixed(1),
      "totalBets": totalbets + 1,
      "averageOdd": summedOdd,
      "averageStake": summedStake,
      "moneyLost": moneyLostSoFar,
      "totalOdd": totalOdd,
      "totalStake": totalStake,
    };
  }
}
