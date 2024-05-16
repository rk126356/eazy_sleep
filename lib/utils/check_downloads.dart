import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_sleep/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/music_model.dart';

void checkDownloads(BuildContext context) async {
  final userProvider =
      Provider.of<UserProvider>(context, listen: false).userData;

  final snapshot = await FirebaseFirestore.instance
      .collection('users/${userProvider.uid}/myMixes')
      .get();

  final mixes = snapshot.docs.map((doc) => doc.data()).toList();

  for (final mixData in mixes) {
    final querySnapshot = FirebaseFirestore.instance
        .collection('users/${userProvider.uid}/myMixes')
        .doc(mixData['mixId']);
    List<MusicModel> players = listFromJson(mixData['mixSongs']);
    String _audioPath = "";
    bool downloaded = false;
    int download = 0;
    for (final music in players) {
      try {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        _audioPath = '$appDocPath/${music.id}.mp3';

        // Check if the file already exists
        if (await File(_audioPath).exists()) {
          print("File already exists. Skipping download.");
          download++;
        }
      } catch (e) {
        print("Error checking downloads file: $e");
      }
    }
    if (download == players.length) {
      downloaded = true;
    }
    await querySnapshot.update({'isDownloaded': downloaded ? true : false});
    print(downloaded);
  }
}
