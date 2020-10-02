import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourturn_client/model/user.dart';
import 'package:yourturn_client/utility/colore.dart';
import 'package:yourturn_client/utility/stile_text.dart';
import 'cell_view.dart';

class DetailedUserView extends StatefulWidget {
  User _user;

  DetailedUserView(this._user);

  @override
  _DetailedUserViewState createState() => _DetailedUserViewState();
}

class _DetailedUserViewState extends State<DetailedUserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Colore.back2,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
              alignment: Alignment.center,
              color: Colore.back1,
              child: Text(
                'UTENTE',
                style: StileText.titolo,
              ),
            ),
          ),
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
            Text(widget._user.annonascita, style: StileText.corpo),
          ),
          CellView(
            'Sesso',
            Text(widget._user.sesso, style: StileText.corpo),
          ),
          CellView(
            'Telefono',
            FlatButton(
              color: Colore.back1,
              child: Text(widget._user.telefono, style: StileText.corpo),
              onPressed: () async {
                await FlutterPhoneDirectCaller.callNumber(
                    widget._user.telefono);
              },
            ),
          ),
          CellView(
              'Email',
              FlatButton(
                color: Colore.back1,
                child: Text(widget._user.email, style: StileText.corpo),
                onPressed: () async {
                  await launch('mailto:${widget._user.email}');
                },
              )),
        ],
      ),
    );
  }
}
