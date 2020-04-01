

class UserTicket {
  String id;
  String resultOdd;
  String cashout;
  int bet;
  int tipNumber;
  int ticketNum;
  String ticketStatus;
  String processFinished;
  String date;

  UserTicket(
      {this.bet,
      this.id,
      this.cashout,
      this.resultOdd,
      this.ticketNum,
      this.ticketStatus,
      this.processFinished,
      this.date,
      this.tipNumber});

  UserTicket.fromMap(Map<String, dynamic> map, String docId) {
    id = docId;
    resultOdd = map["resultOdd"];
    cashout = map["cashout"];
    bet = map["bet"];
    tipNumber = map["tipNumber"];
    ticketNum = map["ticketNum"];
    ticketStatus = map["ticketStatus"];
    date = map["date"];
    processFinished = map["processFinished"];
  }

  UserTicket.initialData(){
    resultOdd = "";
    cashout = "";
    bet = 0;
    tipNumber = 0;
    ticketNum = 0;
    ticketStatus = "";
    date = "";
    processFinished = "";
  }

  Map<String, dynamic> toMap(String odd, String cash, int bet, int tipNum,
      int ticketNum) {
    return {
      "resultOdd": odd,
      "cashout": cash,
      "bet": bet,
      "tipNumber": tipNum,
      "ticketNum": ticketNum,
      "ticketStatus": "active", 
      "processFinished": "no",
      "date": DateTime.now().toString().substring(0, 10),
    };
  }
}
