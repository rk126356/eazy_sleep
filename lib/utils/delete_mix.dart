import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_sleep/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void deleteMix(String mixId, BuildContext context) async {
  final userProvider =
      Provider.of<UserProvider>(context, listen: false).userData;
  final querySnapshot = FirebaseFirestore.instance
      .collection('users/${userProvider.uid}/myMixes')
      .doc(mixId);
  await querySnapshot.delete();
}
