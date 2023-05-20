import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rainyroute/Screens/home_screen.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:rainyroute/Reusable_widgets/password_field.dart';
import 'package:rainyroute/Reusable_widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  late String myError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 46, 51, 82)
              .withOpacity(0.9), //change your color here
        ),
        title: Text(
          'Rejestracja',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9)),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor('#EDE6CB'),
              hexStringToColor('#F6F5F3'),
              hexStringToColor('#FCFBF9'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Podaj nazwę użytkownika",
                    Icons.person_outlined, false, _nameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Wprowadź Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                PasswordField(
                  controller: _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseButton(context, 'ZAREJESTRUJ SIĘ', () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    User? user = value.user;
                    user?.updateDisplayName(_nameTextController.text);
                    // print('Created New Account');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }).onError((error, stackTrace) {
                    switch (error.toString()) {
                      case '[firebase_auth/unknown] Given String is empty or null':
                        myError =
                            'The username, email or password was not given';
                        popUpErrorMessage(context, myError);
                        break;
                      case '[firebase_auth/invalid-email] The email address is badly formatted.':
                        myError =
                            'The email address is badly formatted. Please enter a valid email address';
                        popUpErrorMessage(context, myError);
                        break;
                      case '[firebase_auth/weak-password] Password should be at least 6 characters':
                        myError =
                            'The password is weak. Please enter at least 6 characters';
                        popUpErrorMessage(context, myError);
                        break;
                      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
                        myError = 'The email already used. Go to login page';
                        popUpErrorMessage(context, myError);
                        break;
                    }
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
