import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryListWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryListWidget({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.quicksand(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16.0, // Increased font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
