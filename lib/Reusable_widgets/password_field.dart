import 'package:flutter/material.dart';
import 'package:rainyroute/Utils/color_utils.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _PasswordFieldState createState() => _PasswordFieldState(controller);
}

class _PasswordFieldState extends State<PasswordField> {
  _PasswordFieldState(this.controller);
  TextEditingController controller;
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  final bool _isPasswordType = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      }
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !_obscured,
      focusNode: textFieldFocusNode,
      enableSuggestions: !_isPasswordType,
      autocorrect: !_isPasswordType,
      cursorColor: const Color.fromARGB(255, 46, 51, 82),
      style: TextStyle(
        color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock,
          color: Color.fromARGB(255, 46, 51, 82),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
              color: hexStringToColor('#FFA957'),
            ),
          ),
        ),
        labelText: 'Hasło',
        labelStyle: TextStyle(
          color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: hexStringToColor('#EDE6CB').withOpacity(0.7),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
