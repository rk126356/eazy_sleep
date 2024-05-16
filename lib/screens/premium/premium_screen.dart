import 'package:eazy_sleep/common/fonts.dart';
import 'package:eazy_sleep/widgets/category_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../music/inside_category_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'premium',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  )),
                ),
                const SizedBox(height: 50.0),
                Text(
                  'No premium is needed.',
                  style: AppFonts.appBar,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Everything is free!',
                  style: AppFonts.appBar,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
