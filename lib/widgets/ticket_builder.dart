import 'package:flutter/material.dart';
import 'package:fun_app/models/odd_model.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:provider/provider.dart';

class TicketBuilder extends StatefulWidget {
  final OddModel model;
  const TicketBuilder({Key key, @required this.model}) : super(key: key);

  @override
  _TicketBuilderState createState() => _TicketBuilderState();
}

class _TicketBuilderState extends State<TicketBuilder> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.75),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "${widget.model.minute}",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 28,
                        width: 64,
                        child: Text(
                          widget.model.host,
                          maxLines: (widget.model.host.contains(" ") &&
                                      widget.model.host.length >= 10 ||
                                  widget.model.host.length < 22)
                              ? 2
                              : 1,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        " - ",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(width: 2),
                      Container(
                        alignment: Alignment.center,
                        height: 28,
                        width: 64,
                        child: Text(
                          widget.model.guest,
                          maxLines: (widget.model.guest.contains(" ") &&
                                      widget.model.guest.length >= 10 ||
                                  widget.model.guest.length < 22)
                              ? 2
                              : 1,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  coefDisplay(widget.model.pick),
                  SizedBox(width: 12),
                  coeficientDisplay(coeficient(widget.model.pick)),
                  SizedBox(
                    width: 10,
                  ),
                  Consumer<BetProvider>(
                    builder: (_, betProvider, __) => GestureDetector(
                      onTap: () {
                        return betProvider.removeMatch(widget.model,
                            betProvider.oddModel.indexOf(widget.model));
                      },
                      child: Icon(
                        Icons.restore_from_trash,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget coefDisplay(String pick) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            pick,
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String coeficient(String pick) {
    if (pick == "1") {
      return widget.model.coefHost;
    } else if (pick == "2") {
      return widget.model.coefGuest;
    } else if (pick == "X") {
      return widget.model.coefDraw;
    } else
      return "No data";
  }

  Widget coeficientDisplay(String odd) {
    return Container(
      height: 28,
      width: 36,
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: Colors.white),
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              odd,
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
