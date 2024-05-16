import 'package:eazy_sleep/widgets/category_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../music/inside_category_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'explore',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                )),
              ),
              const SizedBox(
                height: 5,
              ),
              // Search Container
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Text('Search...',
                        style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Row with larger background color containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InsideCategoryScreen(
                                    categoryName: 'Sleep Musics',
                                  )),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 0, 0, 1),
                              Color.fromRGBO(255, 0, 212, 0.698)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(36.0), // Increased padding
                        child: Text('Sleep\nMusics',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InsideCategoryScreen(
                                    categoryName: 'Sleep Sounds',
                                  )),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 89, 255, 1),
                              Color.fromRGBO(0, 255, 0, 0.7)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(36.0), // Increased padding
                        child: Text('Sleep\nSounds',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InsideCategoryScreen(
                                    categoryName: 'Animal Sounds',
                                  )),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 162, 255, 1),
                              Color.fromRGBO(191, 0, 255, 0.694)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(36.0), // Increased padding
                        child: Text('Animal\nSounds',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InsideCategoryScreen(
                                    categoryName: 'Rain Musics',
                                  )),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(230, 175, 36, 1),
                              Color.fromRGBO(189, 36, 62, 0.698)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding:
                            const EdgeInsets.all(36.0), // Increased padding
                        child: Text('Rain\nMusics',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              CategoryListWidget(
                title: 'New',
                onTap: () {},
              ),
              CategoryListWidget(
                title: 'Popular',
                onTap: () {},
              ),

              CategoryListWidget(
                title: 'Trending',
                onTap: () {},
              ),

              CategoryListWidget(
                title: 'White Noise',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InsideCategoryScreen(
                              categoryName: 'White Noise',
                            )),
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
