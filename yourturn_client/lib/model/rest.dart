import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yourturn_client/model/queue.dart';
import 'package:yourturn_client/model/ticket.dart';
import 'package:yourturn_client/model/user.dart' as myuser;
import '../main.dart';

class Rest {
  Future<dynamic> test() async {
    return await _requestByGet('test');
  }

  Future<void> createUser(myuser.User user) async {
    await _requestByPost('signin', user.toMap());
  }

  Future<String> getUser(String uid) async {
    return await _requestByPost('login', {'uid': uid});
  }

  Future<String> createQueue(String id, String luogo, String uid) async {
    return await _requestByPost(
        'createqueue', {'id': id, 'luogo': luogo, 'uid': uid});
  }

  Future<String> enqueue(String id, String uid) async {
    return await _requestByPost('enqueue', {'id': id, 'uid': uid});
  }

  Future<String> getQueue(String id) async {
    return await _requestByPost('getqueue', {'id': id});
  }

  Future<void> setQueue(Queue queue) async {
    await _requestByPost('setqueue', queue.toMap());
  }

  Future<String> getTicket(String number) async {
    return await _requestByPost('getticket', {'numberid': number});
  }

  Future<void> setTicket(Ticket ticket) async {
    await _requestByPost('setticket', ticket.toMap());
  }

  Future<void> next(String id) async {
    await _requestByPost('next', {'id': id});
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
    final response = await Client().get(Uri.parse(indirizzoRoot + url));
    return response.statusCode;
  }
}
