import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart' as myuser;
import '../main.dart';

class RestFunctions {

  Future<dynamic> test() async {
    return await _requestByGet('test');
  }
  Future<dynamic> createUser(myuser.User user) async {
    return await _requestByPost('signin', user.toMap());
  }

  Future<dynamic> getUser(String uid) async {
    return await _requestByPost('login', {'uid': uid});
  }

  Future<dynamic> createQueue(Queue queue) async {
    return await _requestByPost('createqueue', queue.toMap());
  }

  Future<dynamic> enqueue(Ticket ticket) async {
    return await _requestByPost('enqueue', ticket.toMap());
  }

  Future<dynamic> getQueue(String id) async {
    return await _requestByPost('getqueue', {'id': id});
  }

  Future<dynamic> getTicket(String number) async {
    return await _requestByPost('getticket', {'numberid': number});
  }

  Future<dynamic> setTicket(Ticket ticket) async {
    return await _requestByPost('setticket', ticket.toMap());
  }

  Future<dynamic> next(String id) async {
    return await _requestByPost('next', {'id': id});
  }

  Future<String> _requestByPost(String url, Map el) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    dynamic body = json.encode(el);
    final response = await Client()
        .post(Uri.parse(indirizzoRoot + url), headers: header, body: body);
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  Future<int> _requestByGet(String url) async {
    final response = await Client()
        .get(Uri.parse(indirizzoRoot + url));
    return response.statusCode;
  }
}
