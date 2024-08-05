import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ventures/MusicScreen/add_song.dart';
import 'package:ventures/MusicScreen/miidle_screen.dart';
import 'package:ventures/MusicScreen/songs.dart';
// import 'package:ventures/MusicScreen/song_creation_bottom_sheet.dart'; // Make sure to import this

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 1; // Start with the middle icon selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.secondary,
        index: _page,
        items: const [
          Icon(Icons.home, color: Colors.green),
          Icon(Icons.queue_music, color: Colors.green),
          Icon(Icons.music_note, color: Colors.green),
        ],
        onTap: (index) {
          if (index == 1) {
            // Show bottom sheet when middle icon is tapped
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SongCreationBottomSheet(),
            );
          } else {
            setState(() {
              _page = index;
            });
          }
        },
      ),
    );
  }

  Widget _getBody() {
    switch (_page) {
      case 0:
        return SongScreen();
      case 2:
        return AddSongs();
      default:
        return SongScreen(); // You can decide what to show by default
    }
  }
}