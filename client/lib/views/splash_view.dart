import 'package:client/providers/auth_provider.dart';
import 'package:client/views/home_view.dart';
import 'package:client/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool? isLoggedin = Provider.of<AuthProvider>(context).isLoggedin;
    if (isLoggedin != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (isLoggedin == false) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (isLoggedin == true) {
          Navigator.pushReplacementNamed(context, ProfileView.routeName);
        }
      });
    }


    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        alignment: Alignment.center,
        child: const Text(
          'Bienvenue  dans l\'application !',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
