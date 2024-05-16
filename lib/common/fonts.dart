import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle text =
      GoogleFonts.quicksand(textStyle: const TextStyle(color: Colors.white));
  static TextStyle appBar = GoogleFonts.quicksand(
      textStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22));
}
