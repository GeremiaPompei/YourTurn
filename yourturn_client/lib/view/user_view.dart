import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/controller/main_controller.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'create_cell_view.dart';

class UserView extends StatefulWidget {
  MainController _controller;

  UserView(this._controller);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Colore.back2,
      child: ListView(
        children: [
          CreateCellView(
            'Nome',
            Text(widget._controller.user.nome),
          ),
          CreateCellView(
            'Cognome',
            Text(widget._controller.user.cognome),
          ),
          CreateCellView(
            'Anno di Nascita',
            Text(widget._controller.user.anno_nascita),
          ),
          CreateCellView(
            'Sesso',
            Text(widget._controller.user.sesso),
          ),
          CreateCellView(
            'Telefono',
            Text(widget._controller.user.telefono),
          ),
          CreateCellView(
            'Email',
            Text(widget._controller.user.email),
          ),
          Container(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colore.back1,
            child: Icon(Icons.exit_to_app,color: Colore.front1),
            onPressed: () {
              setState(() {
                widget._controller.logOut().then((value) =>
                    Navigator.pushNamedAndRemoveUntil(context, '/authenticate',
                            (route) => route.popped == null));
              });
            },
          ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }
}
