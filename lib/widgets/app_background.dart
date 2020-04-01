import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth;
      final double height = constraints.maxHeight;
      
      return Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
          ),
          Positioned(
            bottom: height * 0.1,
            left: -(height/2 - width/2),
            child: Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.100)
              ),
            ),
          ),
          Positioned(
            left: -(width/10),
            top: -(height/2.5),
            child: Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.101)
              ),
            ),
          ),
          Positioned(
            top: -(width/2.5),
            right: -(width/2.5),
            child: Container(
              height: width,
              width: width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.102)
              ),
            ),
          ),
        ],
      );
    });
  }
}
