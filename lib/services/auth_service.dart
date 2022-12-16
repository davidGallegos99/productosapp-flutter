import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firabseToken = 'AIzaSyBaUQzYWAnGqSxAvQfmHdsKIyYj1RVoS3k';
  final storage = const FlutterSecureStorage();
  bool loading = false;

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firabseToken});
    final res = await http.post(url, body: authData);
    Map<String, dynamic> data = jsonDecode(res.body);
    if (data.containsKey('idToken')) {
      await storage.write(key: 'token', value: data['idToken']);
      return null;
    }
    final Map<String, dynamic> error = jsonDecode(res.body);
    return error['error']['message'];
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firabseToken});
    final res = await http.post(url, body: authData);
    Map<String, dynamic> data = jsonDecode(res.body);
    if (data.containsKey('idToken')) {
      await storage.write(key: 'token', value: data['idToken']);
      return null;
    }
    return data['error']['message'];
  }

  Future logout() async {
    await storage.deleteAll();
  }

  Future<String> verifyToken() async {
    final res = await storage.read(key: 'token');
    return res ?? '';
  }
}
