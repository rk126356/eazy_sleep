import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/providers/timer_provider.dart';
import 'package:eazy_sleep/screens/login/login_screen.dart';
import 'package:eazy_sleep/screens/navigation/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PlayerProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => TimerProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  final bool deb = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EazySleep',
      debugShowCheckedModeBanner: false,
      home: deb
          ? BottomNavigationScreen()
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;

                  if (user != null) {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    userProvider.setUserData(UserModel(
                        uid: user.uid,
                        name: user.displayName,
                        avatarUrl: user.photoURL,
                        email: user.email));
                    return BottomNavigationScreen();
                  } else {
                    return const LoginScreen();
                  }
                } else {
                  // Waiting for the connection to establish
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
    );
  }
}
