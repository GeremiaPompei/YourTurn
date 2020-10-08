import 'dart:convert';
import 'package:http/http.dart';
import '../main.dart';

class Rest {
  Future<bool> test() async {
    return (await requestByGet('test')) != null;
  }

  Future<String> createUser(
      String uid,
      String tokenid,
      String nome,
      String cognome,
      String annonascita,
      String sesso,
      String email,
      String telefono) async {
    return await requestByPut('createuser', {
      'uid': uid,
      'tokenid': [tokenid],
      'nome': nome,
      'cognome': cognome,
      'annonascita': annonascita,
      'sesso': sesso,
      'email': email,
      'telefono': telefono,
    });
  }

  Future<String> getUser(String uid) async {
    return await requestByGet('getuser/' + uid);
  }

  Future<String> removeUser(String uid) async {
    return await requestByDelete('removeuser/' + uid);
  }

  Future<dynamic> addTokenidUser(String uid, String tokenid) async {
    return await requestByPost('addtokeniduser', {
      'uid': uid,
      'tokenid': tokenid,
    });
  }

  Future<dynamic> removeTokenidUser(String uid, String tokenid) async {
    return await requestByPost('removetokeniduser', {
      'uid': uid,
      'tokenid': tokenid,
    });
  }

  Future<String> createQueue(String id, String luogo, String uid) async {
    return await requestByPut(
        'createqueue', {'id': id, 'luogo': luogo, 'uid': uid});
  }

  Future<String> enqueue(String id, String uid) async {
    return await requestByPost('enqueue', {'id': id, 'uid': uid});
  }

  Future<String> getQueue(String id) async {
    return await requestByGet('getqueue/' + id);
  }

  Future<String> closeQueue(String id) async {
    return await requestByDelete('closequeue/' + id);
  }

  Future<String> getTicket(String numberid) async {
    return await requestByGet('getticket/' + numberid);
  }

  Future<String> getBlackListChars() async {
    return await requestByGet('blacklistchars');
  }

  Future<String> next(String id) async {
    return await requestByPost('next', {'id': id});
  }

  Future<String> requestByPost(String url, Map el) async {
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

  Future<String> requestByPut(String url, Map el) async {
    String element;
    Map<String, String> header = {"Content-Type": "application/json"};
    dynamic body = json.encode(el);
    final response = await Client()
        .put(Uri.parse(indirizzoRoot + url), headers: header, body: body);
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  Future<String> requestByGet(String url) async {
    String element;
    final response = await Client().get(Uri.parse(indirizzoRoot + url));
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }

  Future<String> requestByDelete(String url) async {
    String element;
    final response = await Client().delete(Uri.parse(indirizzoRoot + url));
    if (response.statusCode == 200) {
      element = response.body;
    }
    return element;
  }
}
