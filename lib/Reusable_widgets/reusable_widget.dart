import 'package:flutter/material.dart';
import 'package:rainyroute/Reusable_widgets/route_weather_message.dart';
import 'package:rainyroute/Reusable_widgets/weather_message.dart';
import 'package:rainyroute/Screens/reset_password_screen.dart';
import 'package:rainyroute/Screens/signup_screen.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:rainyroute/Reusable_widgets/pop_up_email_message.dart';

import 'pop_up_error_message.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 180,
    height: 180,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: const Color.fromARGB(255, 46, 51, 82),
    style: TextStyle(
      color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
    ),
    decoration: InputDecoration(
      errorStyle: const TextStyle(
        color: Colors.red,
        wordSpacing: 5.0,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color.fromARGB(255, 46, 51, 82),
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: hexStringToColor('#EDE6CB').withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return hexStringToColor('#E1944D'); //Colors.black26;
            }
            return hexStringToColor('#FFA957');
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: hexStringToColor('#F7F6F4'), //Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Nie masz konta? ",
        style: TextStyle(
            color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.8)),
      ),
      GestureDetector(
        onTap: (() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        }),
        child: Text(
          'Zarejestruj się',
          style: TextStyle(
              color: hexStringToColor('#FFA957'), fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> popUpErrorMessage(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomErrorMessage(
        errorText: text,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> popUpEmailMessage(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomEmailMessage(
        errorText: text,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> weatherMessage(
    BuildContext context,
    String city,
    String day,
    double temp,
    double tempMax,
    double tempMin,
    String weatherIcon,
    String weatherCondition) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomMessage(
        cityName: city,
        dayName: day,
        temperature: temp,
        temperatureMax: tempMax,
        temperatureMin: tempMin,
        weatherCondition: weatherCondition,
        weatherIcon: weatherIcon,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 5,
      duration: const Duration(seconds: 20),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> routeMessage(
  BuildContext context,
  String distance,
  String time,
  int temp,
  int tempMax,
  int tempMin,
  String weatherIcon,
  String weatherCondition,
  String humidity,
  String pressure,
  String windSpeed,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomRouteMessage(
        distance: distance,
        time: time,
        temperature: temp,
        temperatureMax: tempMax,
        temperatureMin: tempMin,
        weatherCondition: weatherCondition,
        weatherIcon: weatherIcon,
        humidity: humidity,
        pressure: pressure,
        windSpeed: windSpeed,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 35,
      duration: const Duration(minutes: 5),
      width: MediaQuery.of(context).size.width,
    ),
  );
}

Widget forgetPassword(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 35,
    alignment: Alignment.bottomRight,
    child: TextButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => const ResetPasswordScreen()))),
      child: Text(
        'Nie pamiętasz hasła?',
        style: TextStyle(
          color: hexStringToColor('#FFA957').withOpacity(0.9),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.right,
      ),
    ),
  );
}

Drawer myDrawer(BuildContext context, String email, String name) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(name),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
          ),
        ),
      ],
    ),
  );
}

Widget addressTextField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String label,
  required String hint,
  required double width,
  required Icon prefixIcon,
  Widget? suffixIcon,
  required Function(String) locationCallback,
}) {
  return SizedBox(
    width: width * 0.8,
    child: TextField(
      onChanged: (value) {
        locationCallback(value);
      },
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue.shade300,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(15),
        hintText: hint,
      ),
    ),
  );
}
