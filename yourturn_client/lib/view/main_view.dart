import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/create_view.dart';
import 'package:yourturn_client/view/history_view.dart';
import 'package:yourturn_client/view/navigation_bar.dart';
import 'package:yourturn_client/view/user_view.dart';

class MainView extends StatefulWidget {
  MainController _controller;

  MainView(this._controller);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _indexItem;
  Widget _bodyWidget;

  @override
  void initState() {
    _onItemTapped(0);
  }

  void _onItemTapped(int index) {
    setState(() {
      this._indexItem = index;
      switch (index) {
        case 0:
          this._bodyWidget = HistoryView(widget._controller);
          break;
        case 1:
          this._bodyWidget = CreateView(widget._controller);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          NavigationBar.titles[this._indexItem],
          style: StileText.titolo,
        ),
        actions: [
          IconButton(
            color: Colore.front1,
            icon: Icon(Icons.person),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: UserView(widget._controller),
                    );
                  });
            },
          ),
        ],
        backgroundColor: Colore.back1,
      ),
      body: _bodyWidget,
      bottomNavigationBar: NavigationBar(this._indexItem, _onItemTapped),
    );
  }
}
