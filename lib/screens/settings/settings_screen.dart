import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colors.dart';
import '../../utils/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.textColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black, // Set the background color to black for dark mode
        child: Column(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.info, color: Colors.white),
              title:
                  const Text("About Us", style: TextStyle(color: Colors.white)),
              trailing: const Icon(
                CupertinoIcons.forward,
                color: Colors.white,
              ),
              onTap: () {
                open('https://raihansk.com/current-affairs-and-gk/');
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.mail, color: Colors.white),
              title: const Text("Contact Us",
                  style: TextStyle(color: Colors.white)),
              trailing: const Icon(
                CupertinoIcons.forward,
                color: Colors.white,
              ),
              onTap: () {
                open('https://raihansk.com/contact/');
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.lock, color: Colors.white),
              title: const Text("Privacy Policy",
                  style: TextStyle(color: Colors.white)),
              trailing: const Icon(
                CupertinoIcons.forward,
                color: Colors.white,
              ),
              onTap: () {
                open(
                    'https://raihansk.com/current-affairs-and-gk/privacy-policy-daily-current-affairs-and-gk/');
              },
            ),
            ListTile(
              title:
                  const Text('Sign Out', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              },
            ),
            if (kDebugMode)
              ListTile(
                leading: const Icon(CupertinoIcons.lock, color: Colors.white),
                title: const Text("Clear Data",
                    style: TextStyle(color: Colors.white)),
                trailing: const Icon(
                  CupertinoIcons.forward,
                  color: Colors.white,
                ),
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                },
              ),
          ],
        ),
      ),
    );
  }
}
