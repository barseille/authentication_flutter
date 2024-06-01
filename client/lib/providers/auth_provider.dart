import 'dart:async';

import 'package:client/models/signin_form_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/signup_form_model.dart';
import '../models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  // Définit l'adresse de l'ordinateur ou du serveur
  final String host = 'http://10.0.2.2';
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? token;
  Timer? timer;
  bool isLoading = false;
  bool? isLoggedin;

  Future<void> initAuth() async {
    try {
      String? oldToken = await storage.read(key: 'token');
      if (oldToken == null) {
        isLoggedin = false;
      } else {
        token = oldToken;
        await refreshToken();
        if (token != null) {
          isLoggedin = true;
          initTimer();
        } else {
          isLoggedin = false;
        }
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshToken() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$host/api/auth/refresh-token'),
        headers: {'authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        token = json.decode(response.body);
        storage.write(key: 'token', value: token);
      } else {
        signout();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> signup(SignupForm signupForm) async {
    try {
      // Indique que la requête est en cours
      isLoading = true;

      http.Response response = await http.post(
        // Crée l'adresse de la requête avec l'adresse de l'ordinateur et le chemin '/api/user'
        Uri.parse('$host/api/user'),
        headers: {
          // Indique que les données envoyées sont en format JSON
          'Content-type': 'application/json',
        },
        // Convertit les données du formulaire d'inscription en JSON
        body: json.encode(signupForm.toJson()),
      );

      // Indique que la requête est terminée
      isLoading = false;

      if (response.statusCode != 200) {
        // Si le serveur a répondu avec une erreur, renvoie le message d'erreur du serveur
        return json.decode(response.body);
      }

      // Si tout s'est bien passé, renvoie null (aucune erreur)
      return null;
    } catch (e) {
      // Si une erreur s'est produite, la relancer
      rethrow;
    }
  }

  Future<dynamic> signin(SigninForm signinForm) async {
    try {
      // Indique que la requête est en cours
      isLoading = true;
      http.Response response = await http.post(
        Uri.parse('$host/api/auth'),
        headers: {'Content-type': 'application/json'},
        body: json.encode(signinForm.toJson()),
      );

      final Map<String, dynamic> body = json.decode(response.body);
      if (response.statusCode == 200) {
        final User user = User.fromJson(body['user']);
        token = body['token'];
        storage.write(key: 'token', value: token);
        isLoggedin = true;
        initTimer();
        return user;
      } else {
        return body;
      }
    } catch (e) {
      // Si une erreur s'est produite, la relancer
      rethrow;
    }
  }

  void signout() {
    isLoggedin = false;
    token = null;
    storage.delete(key: 'token');
    timer?.cancel();
  }

  void initTimer() {
    timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      refreshToken();
    });
  }
}
