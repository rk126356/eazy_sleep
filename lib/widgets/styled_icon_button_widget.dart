import 'package:flutter/material.dart';

Widget styledIconButton(IconData icon, {VoidCallback? onPressed}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[800], // Set your desired dark background color
      borderRadius: BorderRadius.circular(8.0), // Adjust as needed
      border: Border.all(
        color: Colors.black, // Set your desired outline color
        width: 2.0, // Adjust as needed
      ),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white), // Set your desired icon color
      onPressed: onPressed,
    ),
  );
}
