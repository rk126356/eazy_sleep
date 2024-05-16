import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colors.dart';
import '../../common/fonts.dart';
import '../../services/audio_services.dart';
import '../../utils/url_launcher.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  double totalCacheSizeInMB = 0;
  double totalCacheSizeInMBDN = 0;

  void fetchCacheSize() async {
    // Call the function to get the total cache size
    double size = await AudioService().getCacheSizeInMB();
    setState(() {
      totalCacheSizeInMB = size;
    });
  }

  void fetchCacheSizeDN() async {
    // Call the function to get the total cache size
    double size = await AudioService().getCacheSizeInMBDN();
    setState(() {
      totalCacheSizeInMBDN = size;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCacheSize();
    fetchCacheSizeDN();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.textColor,
        title: const Text(
          'Storage',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black, // Set the background color to black for dark mode
        child: Column(
          children: [
            ListTile(
              title: const Text('Clear Cache',
                  style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.cached, color: Colors.white),
              trailing: IconButton(
                  onPressed: () {
                    fetchCacheSize();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white60,
                  )),
              subtitle: Text(
                '${totalCacheSizeInMB.toStringAsFixed(2)} MB',
                style: AppFonts.text.copyWith(color: Colors.white70),
              ),
              onTap: () async {
                await AudioService().deleteCacheFiles();
                fetchCacheSize();
              },
            ),
            ListTile(
              title: const Text('Clear Downloads',
                  style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.download, color: Colors.white),
              trailing: IconButton(
                  onPressed: () {
                    fetchCacheSizeDN();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white60,
                  )),
              subtitle: Text(
                '${totalCacheSizeInMBDN.toStringAsFixed(2)} MB',
                style: AppFonts.text.copyWith(color: Colors.white70),
              ),
              onTap: () async {
                await AudioService().deleteCacheFilesDN();
                fetchCacheSizeDN();
              },
            ),
          ],
        ),
      ),
    );
  }
}
