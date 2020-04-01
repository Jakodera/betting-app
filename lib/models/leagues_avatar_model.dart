
class LeagueModel {
  final String searchName;
  final String imgPath;

  LeagueModel({this.searchName, this.imgPath});
}

  List<LeagueModel> leagues = [
    LeagueModel(searchName: "English Premier League", imgPath: "https://i.pinimg.com/originals/c7/08/8d/c7088df551317fb2915a5f15f10ae8ee.jpg"),
    LeagueModel(searchName: "Italian Serie A", imgPath: "https://eplfootballmatch.com/wp-content/uploads/2018/08/serie-a-tim-logo-3.jpg"),
    LeagueModel(searchName: "Spanish La Liga", imgPath: "https://www.sportface.it/wp-content/uploads/2018/03/Logo-Liga-Santander.jpg"),
    LeagueModel(searchName: "French Ligue 1", imgPath: "https://live.staticflickr.com/3355/3526731242_5b40483fe2_c.jpg"),
    LeagueModel(searchName: "German Bundesliga", imgPath: "http://movietvtechgeeks.com/wp-content/uploads/2015/03/german-bundesliga-soccer-week-24-review-2015.jpg"),
    LeagueModel(searchName: "UEFA Europa League", imgPath: "https://logoeps.com/wp-content/uploads/2014/11/UEFA_Europa_League-logo.png"),
  ];