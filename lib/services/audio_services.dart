import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AudioService {
  AudioPlayer audioPlayer = AudioPlayer();
  String _audioPath = "";

  Future<void> saveMp3File(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      _audioPath = '$appDocPath/$fileName.mp3';

      // Check if the file already exists
      if (await File(_audioPath).exists()) {
        print("File already exists. Skipping download.");
        return;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Uint8List data = response.bodyBytes;
        print("File downloaded.");
        File file = File(_audioPath);
        await file.writeAsBytes(data);
      } else {
        print(
            "Failed to download MP3 file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error downloading and saving MP3 file: $e");
    }
  }

  Future<void> deleteMp3File(String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String audioPath = '$appDocPath/$fileName.mp3';

      // Check if the file exists before attempting to delete
      if (await File(audioPath).exists()) {
        await File(audioPath).delete();
        print("File deleted successfully.");
      } else {
        print("File not found. No need to delete.");
      }
    } catch (e) {
      print("Error deleting MP3 file: $e");
    }
  }

  Future<List<String>> getMp3Files() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    List<String> mp3Files = [];
    try {
      Directory directory = Directory(appDocPath);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file.path.endsWith(".mp3")) {
          mp3Files.add(file.path);
        }
      }
    } catch (e) {
      print("Error getting MP3 files: $e");
    }

    return mp3Files;
  }

  Future<void> deleteCacheFiles() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Create a Directory object for the app documents directory
    Directory directory = Directory(appDocPath);

    // Get a list of files in the directory
    List<FileSystemEntity> files = await directory.list().toList();

    // Iterate through the files
    for (FileSystemEntity file in files) {
      // Check if the file is a File (not a Directory) and ends with "_cache"
      if (file is File && file.path.endsWith('_cache.mp3')) {
        // Delete the file
        await file.delete();
        print('Deleted: ${file.path}');
      }
    }
  }

  Future<void> deleteCacheFilesDN() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Create a Directory object for the app documents directory
    Directory directory = Directory(appDocPath);

    // Get a list of files in the directory
    List<FileSystemEntity> files = await directory.list().toList();

    // Iterate through the files
    for (FileSystemEntity file in files) {
      // Check if the file is a File (not a Directory) and ends with "_cache"
      if (file is File && !file.path.endsWith('_cache.mp3')) {
        // Delete the file
        await file.delete();
        print('Deleted: ${file.path}');
      }
    }
  }

  Future<double> getCacheSizeInMB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Create a Directory object for the app documents directory
    Directory directory = Directory(appDocPath);

    // Get a list of files in the directory
    List<FileSystemEntity> files = await directory.list().toList();

    int totalSize = 0;

    // Iterate through the files
    for (FileSystemEntity file in files) {
      // Check if the file is a File (not a Directory) and ends with "_cache.mp3"
      if (file is File && file.path.endsWith('_cache.mp3')) {
        // Get the size of the file and add it to the total size
        totalSize += await file.length();
      }
    }

    // Convert the total size to megabytes
    double totalSizeInMB = totalSize / (1024 * 1024);

    // Return the total size in megabytes
    return totalSizeInMB;
  }

  Future<double> getCacheSizeInMBDN() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Create a Directory object for the app documents directory
    Directory directory = Directory(appDocPath);

    // Get a list of files in the directory
    List<FileSystemEntity> files = await directory.list().toList();

    int totalSize = 0;

    // Iterate through the files
    for (FileSystemEntity file in files) {
      // Check if the file is a File (not a Directory) and ends with "_cache.mp3"
      if (file is File && !file.path.endsWith('_cache.mp3')) {
        // Get the size of the file and add it to the total size
        totalSize += await file.length();
      }
    }

    // Convert the total size to megabytes
    double totalSizeInMB = totalSize / (1024 * 1024);

    // Return the total size in megabytes
    return totalSizeInMB;
  }

  // Future<void> playMp3File(String filePath) async {
  //   await audioPlayer.stop();
  //   await audioPlayer.play(filePath, isLocal: true);
  // }
}
