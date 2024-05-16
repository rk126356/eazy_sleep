import 'package:eazy_sleep/common/colors.dart';
import 'package:eazy_sleep/common/fonts.dart';
import 'package:eazy_sleep/models/music_model.dart';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/services/fetch_musics.dart';
import 'package:eazy_sleep/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InsideCategoryScreen extends StatefulWidget {
  const InsideCategoryScreen({Key? key, required this.categoryName})
      : super(key: key);

  final String categoryName;

  @override
  State<InsideCategoryScreen> createState() => _InsideCategoryScreenState();
}

class _InsideCategoryScreenState extends State<InsideCategoryScreen> {
  bool _isLoading = false;
  bool _isButtonLoading = false;

  List<MusicModel> musicList = [];

  Future<void> fetchMusics() async {
    setState(() {
      _isLoading = true;
    });

    musicList = await FetchMusic().fetchMusicsCategories(widget.categoryName);
    setState(() {
      _isLoading = false;
    });
  }

  void fetchNext() async {
    setState(() {
      _isButtonLoading = true;
    });

    final nextList = await FetchMusic()
        .fetchNext(widget.categoryName, musicList.last.createdAt!);

    setState(() {
      musicList.addAll(nextList);
      _isButtonLoading = false;
    });

    if (nextList.isEmpty) {
      show(context, 'No More ${widget.categoryName} Available');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMusics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.textColor,
        title: Text(
          widget.categoryName,
          style: AppFonts.appBar,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: musicList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildMusicBox(musicList[index]);
                    },
                  ),
                  if (musicList.length > 9)
                    _isButtonLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              fetchNext();
                            },
                            child: const Text('Load More')),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildMusicBox(MusicModel music) {
    final player = Provider.of<PlayerProvider>(context);

    return Container(
      width: 155,
      height: 175,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.network(
                  music.image,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Lock Icon for Paid Songs
              if (music.isPaid)
                const Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              // Play Icon
              Positioned(
                bottom: 35.0,
                left: 16.0,
                right: 16.0,
                child: Center(
                  child: music.isLoading!
                      ? const CircularProgressIndicator()
                      : Container(
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              music.isPlaying!
                                  ? Icons.remove
                                  : Icons.play_arrow,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            onPressed: () {
                              player.addPlayer(music, false);
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                music.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand().copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
