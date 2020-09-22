import 'dart:convert';
import 'package:http/http.dart';
import 'package:yourturn_client/model/user.dart' as myuser;
import '../main.dart';

class RestFunctions {
  static Future<dynamic> signIn(myuser.User user) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    dynamic body = json.encode(user.toMap());
    final response = await _requestByPost(indirizzo + 'signin', header, body);
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  static Future<dynamic> logIn(String uid) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    final response = await _requestByPost(
        indirizzo + 'login', header, json.encode({'uid': uid}));
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  static Future<Response> _responseByGet(
      String word, Map<String, String> header, dynamic body) async {
    return await Client().get(Uri.parse(word));
  }

  static Future<Response> _requestByPost(
      String word, Map<String, String> header, dynamic body) async {
    return await Client().post(Uri.parse(word), headers: header, body: body);
  }
}
