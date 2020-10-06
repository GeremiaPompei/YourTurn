import 'dart:convert';
import 'package:http/http.dart';
import '../main.dart';

class Rest {
  Future<dynamic> test() async {
    return (await requestByGet('test')).statusCode;
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
    return await requestByPost('createuser', {
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
    return await requestByPost('getuser', {'uid': uid});
  }

  Future<String> removeUser(String uid) async {
    return await requestByPost('removeuser', {'uid': uid});
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
    return await requestByPost('createqueue', {
      'id': id,
      'luogo': luogo,
      'uid': uid
    });
  }

  Future<String> enqueue(String id, String uid) async {
    return await requestByPost('enqueue', {'id': id, 'uid': uid});
  }

  Future<String> getQueue(String id) async {
    return await requestByPost('getqueue', {'id': id});
  }

  Future<String> closeQueue(String id) async {
    return await requestByPost('closequeue', {'id': id});
  }

  Future<String> getTicket(String number) async {
    return await requestByPost('getticket', {'numberid': number});
  }

  Future<String> getBlackListChars() async {
    return (await requestByGet('blacklistchars')).body.toString();
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

  Future<Response> requestByGet(String url) async {
    return await Client().get(Uri.parse(indirizzoRoot + url));
  }
}
