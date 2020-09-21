import 'dart:convert';
import 'package:http/http.dart';
import '../main.dart';

class RestFunctions {
  static Future<dynamic> signIn(String nome, String cognome, String eta,
      String sesso, String email, String telefono) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    dynamic body = json.encode({
      'Nome': nome,
      'Cognome': cognome,
      'Eta': eta,
      'Sesso': sesso,
      'Email': email,
      'Telefono': telefono
    });
    final response = await _requestByPost(indirizzo + 'signin', header, body);
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  static Future<Response> _responseByGet(String word) async {
    return await Client().get(Uri.parse(word));
  }

  static Future<Response> _requestByPost(
      String word, Map<String, String> header, dynamic body) async {
    return await Client().post(Uri.parse(word), headers: header, body: body);
  }
}
