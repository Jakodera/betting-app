import 'package:flutter/material.dart';
import 'package:fun_app/providers/bet_provider.dart';
import 'package:provider/provider.dart';

class DisplayTabBar extends StatefulWidget {
  final int index;

  DisplayTabBar({@required this.index});

  @override
  _DisplayTabBarState createState() => _DisplayTabBarState();
}

class _DisplayTabBarState extends State<DisplayTabBar> with SingleTickerProviderStateMixin{

  AnimationController _titleController;
  Animation<double> _titleAnimation;    

  @override
  void initState() {
    _titleController = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this,
    );
    _titleAnimation = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _titleController, 
        curve: Curves.easeInOutBack)..addListener(() {
          setState(() {});
        })
        ..addStatusListener(
          (status) {
            if(status == AnimationStatus.completed) {
              _titleController.reset();
            }
          }
        )
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<BetProvider>(context).oddModel.length;
    _titleController.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildTabBar("Matches", 0),
          buildTabBar("Ticket", 1),
          buildTabBar("History", 2),
          buildTabBar("Profile", 3),
        ],
      ),
    );
  }

  Widget buildTabBar(String name, int currentIndex) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            color: currentIndex == widget.index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            fontSize: (currentIndex == 1 && widget.index != 1) ? 14 * _titleAnimation.value : 14,
          ),
        ),
        SizedBox(height: 5),
        currentIndex == widget.index
            ? Container(
                height: 3,
                width: 3,
                color: Colors.white,
              )
            : Container()
      ],
    );
  }
}
