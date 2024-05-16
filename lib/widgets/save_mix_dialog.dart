import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_sleep/common/fonts.dart';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/providers/user_provider.dart';
import 'package:eazy_sleep/utils/check_downloads.dart';
import 'package:eazy_sleep/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/music_model.dart';
import '../utils/generate_id.dart';

class SaveMixDialog extends StatefulWidget {
  const SaveMixDialog({super.key});

  @override
  State<SaveMixDialog> createState() => _SaveMixDialogState();
}

class _SaveMixDialogState extends State<SaveMixDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  void saveMix(String name) async {
    try {
      final db = FirebaseFirestore.instance;
      final player = Provider.of<PlayerProvider>(context, listen: false);
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).userData;
      final mixId = generateId();
      final mixCollection = await db
          .collection('users/${userProvider.uid}/myMixes')
          .doc(mixId)
          .get();

      await mixCollection.reference.set({
        'mixId': mixId,
        'mixName': name,
        'mixSongs': listToJson(player.players),
        'createdAt': Timestamp.now(),
        'isDownloaded': false,
      });
    } catch (error) {
      print('Error saving mix: $error');
      // Handle the error (e.g., show a snackbar or log the error)
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900], // Set the background color
      title: const Text(
        'Save This Mix',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: _textEditingController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Enter Mix Name',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            'Cancel',
            style: AppFonts.text,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_textEditingController.text.isNotEmpty) {
              saveMix(_textEditingController.text);
              show(context, 'Playlist saved successfully');
              Navigator.of(context).pop();
            } else {
              show(context, 'Please enter a name');
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text(
            'Save',
            style: AppFonts.text,
          ),
        ),
      ],
    );
  }
}
