// ignore_for_file: avoid_print
import 'package:bike_rental/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:bike_rental/login/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

@override
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User? user = FirebaseAuth.instance.currentUser;
            userName = user!.displayName;
            userEmail = user.email;
            userName ??= null;
            print('User Name: $userName');
            print('User Email: $userEmail');
            return Builder(
              builder: (context) => const MainScreen(),
            );
          } else {
            return const LoginSignupScreen();
          }
        },
      ),
    );
  }
}
