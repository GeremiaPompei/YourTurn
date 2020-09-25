import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourturn_client/model/user.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'cell_view.dart';

class UserView extends StatefulWidget {
  User _user;

  UserView(this._user);

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
          CellView(
            'Nome',
            Text(widget._user.nome, style: StileText.corpo),
          ),
          CellView(
            'Cognome',
            Text(widget._user.cognome, style: StileText.corpo),
          ),
          CellView(
            'Anno di Nascita',
            Text(widget._user.anno_nascita, style: StileText.corpo),
          ),
          CellView(
            'Sesso',
            Text(widget._user.sesso, style: StileText.corpo),
          ),
          CellView(
            'Telefono',
            Text(widget._user.telefono, style: StileText.corpo),
          ),
          CellView(
            'Email',
            Text(widget._user.email, style: StileText.corpo),
          ),
        ],
      ),
    );
  }
}
