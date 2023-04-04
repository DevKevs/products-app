import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDkDiecgpzWiq_QQTSY4FLPwQSKOoyKP6Q';
  final storage = const FlutterSecureStorage();
  String userInitials = '';

  Future<String?> signUp(String email, String passw) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': passw,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final res = await http.post(url, body: jsonEncode(authData));

    final Map<String, dynamic> decodedRes = jsonDecode(res.body);

    if (decodedRes.containsKey('idToken')) {
      //if user created return null
      await storage.write(key: 'idToken', value: decodedRes['idToken']);
      await storage.write(key: 'email', value: decodedRes['email']);
      userInitials = email.substring(0, 2).toUpperCase();
      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  Future<String?> signIn(String email, String passw) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': passw,
      'returnSecureToken': true
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final res = await http.post(url, body: jsonEncode(authData));

    final Map<String, dynamic> decodedRes = jsonDecode(res.body);

    if (decodedRes.containsKey('idToken')) {
      //if user login return null
      await storage.write(key: 'idToken', value: decodedRes['idToken']);
      await storage.write(key: 'email', value: decodedRes['email']);
      userInitials = email.substring(0, 2).toUpperCase();
      return null;
    } else {
      return decodedRes['error']['message'];
    }
  }

  Future logOut() async {
    await storage.delete(key: 'idToken');
    await storage.delete(key: 'email');
  }

  Future<String> readStorage() async {
    String? userEmail = await storage.read(key: 'email');
    if (userEmail != null) {
      userInitials = userEmail.substring(0, 2).toUpperCase();
    }
    return await storage.read(key: 'idToken') ?? '';
  }
}
