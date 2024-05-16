import 'package:eazy_sleep/models/music_model.dart';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/providers/timer_provider.dart';
import 'package:eazy_sleep/screens/explore/explore_screen.dart';
import 'package:eazy_sleep/widgets/time_select_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:provider/provider.dart';

import '../../widgets/save_mix_dialog.dart';
import '../../widgets/styled_icon_button_widget.dart';

class PlayingScreen extends StatefulWidget {
  List<MusicModel>? players;
  PlayingScreen({super.key, this.players});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  bool isLoading = false;

  void loadMusic() async {
    if (widget.players != null) {
      setState(() {
        isLoading = true;
      });
      final player = Provider.of<PlayerProvider>(context, listen: false);
      if (player.players.isNotEmpty) {
        await player.stopAllPlayers();
      }
      for (final p in widget.players!) {
        player.addPlayer(p, true);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final timerProvider = Provider.of<TimerProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Text(
                            'mixer',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: player.players.length,
                            itemBuilder: (context, index) {
                              final music = player.players[index];
                              return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.grey[900],
                                  child: musicList(music, player));
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (player.players.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  styledIconButton(
                                      player.allPaused
                                          ? Icons.play_arrow
                                          : Icons.pause, onPressed: () {
                                    player.pauseAll();
                                  }),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  styledIconButton(Icons.playlist_add,
                                      onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const SaveMixDialog();
                                      },
                                    );
                                  }),
                                ],
                              ),
                              if (timerProvider.remainingTime != 0)
                                Text(
                                  '${(timerProvider.remainingTime ~/ 60).toString().padLeft(2, '0')}:${(timerProvider.remainingTime % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    color:
                                        Colors.white, // Text color in dark mode
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[
                                            800], // Set your desired dark background color
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust as needed
                                        border: Border.all(
                                          color: Colors
                                              .black, // Set your desired outline color
                                          width: 2.0, // Adjust as needed
                                        ),
                                      ),
                                      child: const TimerSelectionPopup()),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  styledIconButton(Icons.share, onPressed: () {
                                    // Handle sleep timer button press
                                  }),
                                ],
                              )
                            ],
                          ),
                      ],
                    ),
                    if (player.players.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No music is playing yet.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExploreScreen()),
                                );
                              },
                              child: const Text('Explore'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  ListTile musicList(MusicModel music, PlayerProvider player) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(music.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Stack(children: [
        SizedBox(
          width: 210,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: MarqueeText(
              alwaysScroll: music.name.length > 25 ? true : false,
              text: TextSpan(
                text: music.name,
              ),
              style: GoogleFonts.quicksand().copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              speed: 15,
            ),
          ),
        ),
        Positioned(
            left: 216,
            bottom: -13,
            child: IconButton(
                onPressed: () {
                  player.addPlayer(music, false);
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                )))
      ]),
      subtitle: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                music.player!.volume == 0
                    ? music.player!.setVolume(1)
                    : music.player!.setVolume(0);
              });
            },
            child: Icon(
              music.player!.volume == 0
                  ? LineIcons.volumeMute
                  : music.player!.volume > 0.5
                      ? LineIcons.volumeUp
                      : LineIcons.volumeDown,
              color: Colors.white,
            ),
          ),
          Slider(
              value: music.player!.volume,
              onChanged: (value) {
                setState(() {
                  music.player!.setVolume(value);
                  music.volume = value;
                });
              }),
          IconButton(
              onPressed: () {
                if (music.isPaused!) {
                  music.player!.resume();
                  music.isPaused = false;
                } else {
                  music.player!.pause();
                  music.isPaused = true;
                }
                player.checkPaused();
                setState(() {});
              },
              icon: Icon(
                music.isPaused! ? LineIcons.play : LineIcons.pause,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
