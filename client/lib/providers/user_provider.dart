import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? user;
  AuthProvider? authProvider;
  late String host;

  void update(AuthProvider newAuthProvider, String newHost) {
    authProvider = newAuthProvider;
    host = newHost;
    if (user == null && authProvider != null && authProvider!.isLoggedin == true) {
      fetchCurrentUser();
    }
  }

  void updateUser(User updatedUser) {
    user = updatedUser;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    try {
      if (authProvider != null) {
        http.Response response = await http.get(
          Uri.parse('$host/api/user/current'),
          headers: {'authorization': 'Bearer ${authProvider!.token}'},
        );
        if (response.statusCode == 200) {
          updateUser(User.fromJson(json.decode(response.body)));
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
