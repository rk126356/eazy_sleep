import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/music_model.dart';

class FetchMusic {
  Future<List<MusicModel>> fetchMusics() async {
    List<MusicModel> musicList = [];
    final musicsCollection = FirebaseFirestore.instance
        .collection('all_musics')
        .where('categories', arrayContainsAny: ['Sleep Musics'])
        .orderBy('createdAt', descending: true)
        .limit(10);

    try {
      final querySnapshot = await musicsCollection.get();

      for (final musicData in querySnapshot.docs) {
        final data = musicData.data();

        final music = MusicModel(
          id: data['id'],
          name: data['name'],
          image: data['image'],
          url: data['url'],
          isPaid: data['isPaid'],
          categories: data['categories'],
          createdAt: data['createdAt'],
        );
        musicList.add(music);
      }
    } catch (e) {
      print("Error fetching musics: $e");
    }
    return musicList;
  }

  Future<List<MusicModel>> fetchMusicsCategories(
    String category,
  ) async {
    List<MusicModel> musicList = [];
    final musicsCollection = FirebaseFirestore.instance
        .collection('all_musics')
        .where('categories', arrayContainsAny: [category])
        .orderBy('createdAt', descending: true)
        .limit(10);

    try {
      final querySnapshot = await musicsCollection.get();

      for (final musicData in querySnapshot.docs) {
        final data = musicData.data();

        final music = MusicModel(
          id: data['id'],
          name: data['name'],
          image: data['image'],
          url: data['url'],
          isPaid: data['isPaid'],
          categories: data['categories'],
          createdAt: data['createdAt'],
        );
        musicList.add(music);
      }
    } catch (e) {
      print("Error fetching musics: $e");
    }
    return musicList;
  }

  Future<List<MusicModel>> fetchNext(
    String category,
    Timestamp lastData,
  ) async {
    List<MusicModel> musicList = [];
    final musicsCollection = FirebaseFirestore.instance
        .collection('all_musics')
        .where('categories', arrayContainsAny: [category])
        .orderBy('createdAt', descending: true)
        .startAfter([lastData])
        .limit(10);

    try {
      final querySnapshot = await musicsCollection.get();

      for (final musicData in querySnapshot.docs) {
        final data = musicData.data();

        final music = MusicModel(
          id: data['id'],
          name: data['name'],
          image: data['image'],
          url: data['url'],
          isPaid: data['isPaid'],
          categories: data['categories'],
          createdAt: data['createdAt'],
        );
        musicList.add(music);
      }
    } catch (e) {
      print("Error fetching musics: $e");
    }
    return musicList;
  }
}
