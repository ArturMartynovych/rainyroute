import 'package:flutter/material.dart';

ClipOval locationButton(Function getLocation) {
  return ClipOval(
    child: Material(
      color: Colors.orange.shade100, // button color
      child: InkWell(
        splashColor: Colors.orange, // inkwell color
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.my_location),
        ),
        onTap: () {
          getLocation;
        },
      ),
    ),
  );
}
