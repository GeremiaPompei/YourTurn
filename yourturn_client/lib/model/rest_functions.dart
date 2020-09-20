import 'dart:convert';
import 'package:http/http.dart';

class RestFunctions {
  static const String indirizzo = 'http://localhost:3000/';

  static Future<dynamic> signIn(Map<String, String> params) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    dynamic body = json.encode(params);
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
