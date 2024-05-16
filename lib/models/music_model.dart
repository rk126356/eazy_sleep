import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicModel {
  String id;
  String name;
  String image;
  String url;
  bool isPaid;
  List categories;
  Timestamp? createdAt;
  bool? isPlaying;
  bool? isPaused;
  bool? isLoading;
  AudioPlayer? player;
  double? volume;

  MusicModel({
    required this.id,
    required this.name,
    required this.image,
    required this.url,
    required this.isPaid,
    required this.categories,
    this.createdAt,
    this.isPlaying = false,
    this.isPaused = false,
    this.isLoading = false,
    this.player,
    this.volume = 1.00,
  });

  // Convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'url': url,
      'isPaid': isPaid,
      'isPlaying': isPlaying ?? false,
      'categories': categories,
      'volume': volume ?? 1.00,
    };
  }

  // Create a MusicModel object from a Map
  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      url: json['url'],
      isPaid: json['isPaid'],
      isPlaying: json['isPlaying'] ?? false,
      categories: List.from(
        json['categories'],
      ),
      volume: json['volume'] ?? 1.00,
    );
  }
}

// Convert a list of MusicModel objects to a List<Map<String, dynamic>>
List<Map<String, dynamic>> listToJson(List<MusicModel> musicList) {
  List<Map<String, dynamic>> jsonList = [];
  for (var music in musicList) {
    jsonList.add(music.toJson());
  }
  return jsonList;
}

// Convert a List<Map<String, dynamic>> to a list of MusicModel objects
List<MusicModel> listFromJson(List<dynamic> jsonList) {
  List<MusicModel> musicList = [];
  for (var json in jsonList) {
    musicList.add(MusicModel.fromJson(json));
  }
  return musicList;
}
