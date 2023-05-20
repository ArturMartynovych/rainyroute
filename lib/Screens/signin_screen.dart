import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rainyroute/Screens/home_screen.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rainyroute/Reusable_widgets/password_field.dart';
import 'package:rainyroute/Reusable_widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late String myError;

  @override
  void initState() {
    super.initState();
    isLocationEnabled();
    enableLocation();
    // checkLocationPermissions();
  }

  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> enableLocation() async {
    final isLocationServiceEnabled = await isLocationEnabled();

    if (!isLocationServiceEnabled) {
      final locationPermissionStatus = await Geolocator.checkPermission();

      if (locationPermissionStatus == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      final locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return;
      }

      if (locationPermission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }
      await Geolocator.openLocationSettings();
    } else {
      final permission = await Geolocator.checkPermission();
      final permissionStatus = permission == LocationPermission.denied
          ? await Geolocator.requestPermission()
          : permission;

      if (permissionStatus == LocationPermission.denied) {
      } else {}
    }
  }

  // Future<bool> isLocationEnabled() async {
  //   return await Geolocator.isLocationServiceEnabled();
  // }

  // Future<void> checkLocationPermissions() async {
  //   final permission = await Geolocator.checkPermission();
  //   final permissionStatus = permission == LocationPermission.denied
  //       ? await Geolocator.requestPermission()
  //       : permission;

  //   if (permissionStatus == LocationPermission.denied) {
  //   } else {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Stack(
            children: <Widget>[
              Image.asset('assets/images/bezCircle.png'),
              Image.asset('assets/images/redCircle.png'),
              Image.asset('assets/images/purpleCircle.png'),
              Image.asset('assets/images/orangeCircle.png'),
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/svg/logonew.svg',
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 240,
                    ),
                    reusableTextField("Email", Icons.person_outlined, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordField(
                      controller: _passwordTextController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    forgetPassword(context),
                    firebaseButton(context, 'ZALOGUJ SIĘ', () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        if (value.user?.displayName != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        switch (error.toString()) {
                          case '[firebase_auth/invalid-email] The email address is badly formatted.':
                            myError =
                                'Adres e-mail jest źle sformatowany. Wprowadź prawidłowy adres e-mail.';
                            popUpErrorMessage(context, myError);
                            break;
                          case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
                            myError =
                                'Hasło jest nieprawidłowe lub użytkownik nie ma hasła.';
                            popUpErrorMessage(context, myError);
                            break;
                          case '''[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.''':
                            myError = 'Nie znaleziono użytkownika.';
                            popUpErrorMessage(context, myError);
                            break;
                          case '[firebase_auth/unknown] Given String is empty or null':
                            myError = 'Nie podano adresu e-mail lub hasła.';
                            popUpErrorMessage(context, myError);
                            break;
                          case '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
                            myError =
                                'Wykorzystano wszystkie próby logowania. Spróbuj ponownie później.';
                            popUpErrorMessage(context, myError);
                            break;
                        }
                      });
                    }),
                    signUpOption(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
