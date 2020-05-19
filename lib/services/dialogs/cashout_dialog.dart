import 'package:flutter/material.dart';

class CashOutDialog extends StatefulWidget {
  @override
  _CashOutDialogState createState() => _CashOutDialogState();
}

class _CashOutDialogState extends State<CashOutDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 100,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Congrats!",
                style: TextStyle(color: Colors.green, fontSize: 32.0),
              ),
              Text(
                "Press anywhere to continue...",
                style: TextStyle(height: 2, color: Colors.grey, fontSize: 16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
