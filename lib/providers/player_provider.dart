import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_sleep/models/music_model.dart';
import 'package:eazy_sleep/services/audio_services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PlayerProvider with ChangeNotifier {
  List<MusicModel> players = [];
  bool allPaused = false;

  void pauseAll() {
    if (!allPaused) {
      allPaused = true;
      for (final music in players) {
        music.player!.pause();
        music.isPaused = true;
      }
      print("Paused all players");
    } else {
      allPaused = false;
      for (final music in players) {
        music.player!.resume();
        music.isPaused = false;
      }
      print('Played all players');
    }
    // checkPaused();
    notifyListeners();
  }

  void checkPaused() {
    int playerCount = 0;
    for (final music in players) {
      if (!music.isPaused!) {
        playerCount++;
      }

      if (playerCount != 0) {
        allPaused = false;
      } else {
        allPaused = true;
      }
    }
    notifyListeners();
  }

  Future<void> stopAllPlayers() async {
    for (final music in players) {
      await music.player!.stop();
      await music.player!.dispose();
      music.isPlaying = false;
    }
    players.clear();
    notifyListeners();
  }

  void addPlayer(MusicModel music, bool isDownload) async {
    // Check if a player with the same ID already exists
    final existingPlayer = players.firstWhere((player) => player.id == music.id,
        orElse: () => MusicModel(
            id: '00',
            name: '00',
            image: '00',
            url: '00',
            isPaid: false,
            createdAt: Timestamp.now(),
            categories: ['00']));
    music.isLoading = true;
    notifyListeners();
    if (existingPlayer.id == music.id) {
      if (kDebugMode) {
        print('Already added');
      }
      await existingPlayer.player!.stop();
      await existingPlayer.player!.dispose();
      players.remove(existingPlayer);
      music.isPlaying = false;
    } else {
      if (kDebugMode) {
        print('Playing');
      }
      players.add(music);

      final player = AudioPlayer(playerId: music.id);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(music.volume ?? 1.00);
      music.player = player;
      String _audioPath = "";
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      if (isDownload) {
        _audioPath = '$appDocPath/${music.id}.mp3';
      } else {
        _audioPath = '$appDocPath/${music.id}_cache.mp3';
      }

      // Check if the file already exists
      if (await File(_audioPath).exists()) {
        print("File already exists. Skipping download.");
        await music.player!.play(DeviceFileSource(_audioPath));
      } else {
        await music.player!.play(UrlSource(music.url));

        AudioService().saveMp3File(music.url, '${music.id}_cache');
      }
      if (kDebugMode) {
        print(players.length);
      }
      music.isPlaying = true;
    }
    music.isLoading = false;

    checkPaused();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
