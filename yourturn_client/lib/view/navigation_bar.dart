import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/icona.dart';

class NavigationBar extends StatefulWidget {
  static const titles = ['History','Scan','Create'];
  void Function(int) _tap;
  int _index;

  NavigationBar(this._index,this._tap);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget._index,
      selectedItemColor: Colore.front1,
      unselectedItemColor: Colore.back2,
      backgroundColor: Colore.back1,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icona.prima),
            title: Text(NavigationBar.titles[0]),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icona.seconda),
          title: Text(NavigationBar.titles[1]),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icona.terza),
          title: Text(NavigationBar.titles[2]),
        ),
      ],
      onTap: widget._tap,
    );
  }
}
