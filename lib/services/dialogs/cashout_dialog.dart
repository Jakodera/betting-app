

import 'package:flutter/material.dart';

class CashOutDialog extends StatefulWidget {
  @override
  _CashOutDialogState createState() => _CashOutDialogState();
}

class _CashOutDialogState extends State<CashOutDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 100,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Congrats!",
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}