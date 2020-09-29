import 'package:flutter/material.dart';
import 'colore.dart';
import 'font.dart';

class StileText {
  static final superTitolo = TextStyle(
    fontFamily: Font.titolo,
    fontWeight: FontWeight.w700,
    fontSize: 85,
    color: Colore.front1,
  );

  static final titolo = TextStyle(
    fontFamily: Font.titolo,
    fontWeight: FontWeight.w900,
    fontSize: 35,
    color: Colore.front1,
  );

  static final sottotitolo = TextStyle(
    fontFamily: Font.sottotitolo,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colore.front1,
  );

  static final sottotitoloWhite = TextStyle(
    fontFamily: Font.sottotitolo,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colore.back2,
  );

  static final corpo = TextStyle(
    fontFamily: Font.corpo,
    fontWeight: FontWeight.w500,
    fontSize: 17,
    color: Colore.front1,
  );

  static final corpoMini1 = TextStyle(
    fontFamily: Font.corpo,
    fontWeight: FontWeight.w200,
    fontSize: 15,
    color: Colore.front2,
  );

  static final corpoMini2 = TextStyle(
    fontFamily: Font.corpo,
    fontSize: 15,
    color: Colore.front1,
  );
}