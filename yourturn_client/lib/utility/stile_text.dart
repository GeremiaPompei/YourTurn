import 'package:flutter/material.dart';
import 'colore.dart';
import 'font.dart';

class StileText {
  static final titolo = TextStyle(
    fontFamily: Font.titolo,
    fontWeight: FontWeight.w900,
    fontSize: 35,
    color: Colore.front1,
  );

  static final sottotitolo = TextStyle(
    fontFamily: Font.sottotitolo,
    fontWeight: FontWeight.w900,
    fontSize: 20,
    color: Colore.front1,
  );

  static final corpo = TextStyle(
    fontFamily: Font.corpo,
    fontWeight: FontWeight.w900,
    fontSize: 15,
    color: Colore.front1,
  );
}