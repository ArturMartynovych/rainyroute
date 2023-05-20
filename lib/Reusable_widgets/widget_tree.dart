import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rainyroute/Screens/home_screen.dart';
import 'package:rainyroute/Screens/signin_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WidgetTree> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStatechanges => _firebaseAuth.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authStatechanges,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const SignInScreen();
        }
      }),
    );
  }
}
