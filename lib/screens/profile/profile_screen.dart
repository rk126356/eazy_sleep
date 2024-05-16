import 'package:eazy_sleep/common/fonts.dart';
import 'package:eazy_sleep/providers/user_provider.dart';
import 'package:eazy_sleep/screens/profile/downloads_screen.dart';
import 'package:eazy_sleep/screens/profile/my_mix_screen.dart';
import 'package:eazy_sleep/screens/settings/settings_screen.dart';
import 'package:eazy_sleep/screens/settings/storage_screen.dart';
import 'package:eazy_sleep/services/audio_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
// Call the function to get the total cache size
  double totalCacheSizeInMB = 0;

  void fetchCacheSize() async {
    // Call the function to get the total cache size
    double size = await AudioService().getCacheSizeInMB();
    double sizeDn = await AudioService().getCacheSizeInMBDN();
    setState(() {
      totalCacheSizeInMB = size + sizeDn;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCacheSize();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  userProvider.userData.avatarUrl!,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userProvider.userData.name!,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                userProvider.userData.email!,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // ListTile(
              //   title: const Text('Premium',
              //       style: TextStyle(color: Colors.white)),
              //   leading:
              //       const Icon(Icons.workspace_premium, color: Colors.white),
              //   onTap: () {},
              // ),
              ListTile(
                title: const Text('Downloads',
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.download, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DownloadScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Saved Mixes',
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.music_note, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyMixScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Storage',
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.sd_storage, color: Colors.white),
                // subtitle: Text(
                //   '${totalCacheSizeInMB.toStringAsFixed(2)} MB',
                //   style: AppFonts.text.copyWith(color: Colors.white70),
                // ),
                // trailing: IconButton(
                //     onPressed: () {
                //       fetchCacheSize();
                //     },
                //     icon: const Icon(
                //       Icons.refresh,
                //       color: Colors.white60,
                //     )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StorageScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Settings',
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(Icons.settings, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
