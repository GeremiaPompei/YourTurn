import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/create_view.dart';
import 'package:yourturn_client/view/history_view.dart';
import 'package:yourturn_client/view/navigation_bar.dart';

class MainView extends StatefulWidget {
  MainController _controller;

  MainView(this._controller);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Widget _varWidget;
  int _indexItem;

  @override
  void initState() {
    _onItemTapped(1);
  }

  void _onItemTapped(int index) {
    setState(() {
      this._indexItem = index;
      switch (index) {
        case 0:
          this._varWidget = HistoryView();
          break;
        case 1:
          this._varWidget =
              Container(color: Colore.back2, child: Text(index.toString()));
          break;
        case 2:
          this._varWidget = CreateView();
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
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              setState(() {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/authenticate', (route) => route.popped == null);
              });
            },
          ),
        ],
        backgroundColor: Colore.back1,
      ),
      body: _varWidget,
      bottomNavigationBar: NavigationBar(this._indexItem, _onItemTapped),
    );
  }
}
