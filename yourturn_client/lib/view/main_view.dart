import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'package:yourturn_client/view/createqueue_view.dart';
import 'package:yourturn_client/view/removeuser_view.dart';
import 'package:yourturn_client/view/tickets_view.dart';
import 'package:yourturn_client/view/navigation_bar.dart';
import 'package:yourturn_client/view/detaileduser_view.dart';

import 'buttonback_view.dart';

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
          this._bodyWidget = CreateQueueView(widget._controller);
          break;
        case 1:
          this._bodyWidget = TicketsView(widget._controller);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widget._controller.configMessaging(context);
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
                      content: DetailedUserView(widget._controller.user),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colore.back1,
                            child: Icon(Icons.clear, color: Colore.front1),
                            onPressed: () {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'RIMUOVI UTENTE',
                                          style: StileText.titolo,
                                        ),
                                        content: Container(
                                          padding: EdgeInsets.all(10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          color: Colore.back2,
                                          child: RemoveUserView(
                                              widget._controller),
                                        ),
                                        actions: [
                                          ButtonBackView(),
                                        ],
                                      );
                                    });
                              });
                            },
                          ),
                          FloatingActionButton(
                            backgroundColor: Colore.back1,
                            child:
                                Icon(Icons.exit_to_app, color: Colore.front1),
                            onPressed: () {
                              setState(() {
                                widget._controller.logOut().then((value) =>
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/authenticate',
                                        (route) => route.popped == null));
                              });
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ButtonBackView(),
                      ],
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
