import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_sleep/models/data.dart';
import 'package:eazy_sleep/models/music_model.dart';
import 'package:eazy_sleep/models/user_model.dart';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/providers/user_provider.dart';
import 'package:eazy_sleep/services/fetch_musics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/check_downloads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  List<MusicModel> demoMusicList = [];
  List<MusicModel> fastSleep = [];

  Future<void> fetchMusics() async {
    setState(() {
      _isLoading = true;
    });

    demoMusicList = await FetchMusic().fetchMusics();
    setState(() {
      _isLoading = false;
    });
    fastSleep = await FetchMusic().fetchMusicsCategories(
      'Fast Sleep',
    );
    setState(() {});
  }

  void fetchUser() async {
    setState(() {
      _isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserData(UserModel(
          uid: user.uid,
          name: user.displayName,
          avatarUrl: user.photoURL,
          email: user.email));
    } else {
      print('no user found');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchMusics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/bg1.png'))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      child: Image.asset(
                        'assets/images/cover2.png',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'for you',
                      style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      )),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: demoMusicList.map((music) {
                          return buildMusicBox(music);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'fast sleep',
                      style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      )),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: fastSleep.map((music) {
                          return buildMusicBox(music);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'latest musics',
                      style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      )),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: demoMusicList.map((music) {
                          return buildMusicBox(music);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'latest mixes',
                      style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      )),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: demoMusicList.map((music) {
                          return buildMusicBox(music);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildMusicBox(MusicModel music) {
    final player = Provider.of<PlayerProvider>(context);

    return Container(
      width: 155,
      height: 175,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.network(
                  music.image,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Lock Icon for Paid Songs
              if (music.isPaid)
                const Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              // Play Icon
              Positioned(
                bottom: 35.0,
                left: 16.0,
                right: 16.0,
                child: Center(
                  child: music.isLoading!
                      ? const CircularProgressIndicator()
                      : Container(
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              music.isPlaying!
                                  ? Icons.remove
                                  : Icons.play_arrow,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            onPressed: () {
                              player.addPlayer(music, false);
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                music.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand().copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
