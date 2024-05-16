import 'package:eazy_sleep/utils/check_downloads.dart';
import 'package:eazy_sleep/widgets/confirm_popup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../common/fonts.dart';
import '../../models/music_model.dart';
import '../../providers/user_provider.dart';
import '../../screens/music/playing_screen.dart';
import '../../services/audio_services.dart';
import '../../utils/delete_mix.dart';
import '../../utils/update_mix.dart';

class MyMixScreen extends StatefulWidget {
  const MyMixScreen({Key? key}) : super(key: key);

  @override
  State<MyMixScreen> createState() => _MyMixScreenState();
}

class _MyMixScreenState extends State<MyMixScreen> {
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    checkDownloads(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false).userData;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'My Mixes',
          style: AppFonts.appBar,
        ),
        backgroundColor: Colors.grey[900], // Dark app bar color
      ),
      body: Container(
        color: Colors.grey[800], // Dark background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users/${userProvider.uid}/myMixes')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No saved mixes found.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18.0,
                    ),
                  ),
                );
              }

              final mixes = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

              return ListView.builder(
                itemCount: mixes.length,
                itemBuilder: (context, index) {
                  final mixData = mixes[index];
                  final mixName = mixData['mixName'] ?? 'Unnamed Mix';
                  final mixId = mixData['mixId'] ?? 'None';
                  final isDownloaded = mixData['isDownloaded'] ?? false;

                  List<MusicModel> players = listFromJson(mixData['mixSongs']);

                  return Card(
                    elevation: 4.0,
                    color: Colors.grey[700], // Dark card color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayingScreen(
                              players: players,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        mixName,
                        style: AppFonts.text.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isDownloaded
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isDownloading = true;
                                    });
                                    for (final music in players) {
                                      AudioService().deleteMp3File(
                                        music.id,
                                      );
                                    }
                                    setState(() {
                                      _isDownloading = false;
                                    });
                                    updateMix(mixId, true, context);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              : _isDownloading
                                  ? const CircularProgressIndicator()
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isDownloading = true;
                                        });
                                        for (final music in players) {
                                          AudioService().saveMp3File(
                                            music.url,
                                            music.id,
                                          );
                                        }
                                        setState(() {
                                          _isDownloading = false;
                                        });
                                        updateMix(mixId, false, context);
                                      },
                                      icon: const Icon(
                                        LineIcons.download,
                                        color: Colors.white,
                                      ),
                                    ),
                          IconButton(
                            onPressed: () {
                              popUp(
                                  content: 'Are you sure?',
                                  title: 'Delete Mix',
                                  context: context,
                                  onOk: () {
                                    deleteMix(mixId, context);
                                  });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
