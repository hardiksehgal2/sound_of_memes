import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ventures/MusicScreen/add_song.dart';
import 'package:ventures/MusicScreen/example.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/components/my_drawer.dart';
import 'package:ventures/models/all_songs.dart';
// import 'package:ventures/SplashScreen.dart'; // Ensure this import is correct

class SongScreen extends StatefulWidget {
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  int _page = 0;

  late Future<AllSongs> futureSongs;
  late AudioPlayer audioPlayer;
  int? currentPlayingIndex;
  String currentPlayingUrl = '';

  @override
  void initState() {
    super.initState();
    futureSongs = fetchSongs();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<AllSongs> fetchSongs() async {
    final response = await http
        .get(Uri.parse('http://143.244.131.156:8000/allsongs?page=1'));

    if (response.statusCode == 200) {
      return AllSongs.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load songs');
    }
  }

  void navigateToExample(Songs song, int index, List<Songs> allSongs) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Example(
          songUrl: song.songUrl,
          imageUrl: song.imageUrl,
          title: song.songName,
          artist: song.userId ?? 'Unknown Artist',
          allSongs: allSongs,
          currentIndex: index,
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              _logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Implement your logout logic here, e.g., clearing user data, tokens, etc.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MySplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recent Songs",
          textAlign: TextAlign.center,
          style: GoogleFonts.pottaOne(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            // color: textColor1,
          ),
        ),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/images/pepe_calm.png'), // Replace with your image URL
            ),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const MyDrawer(),
      body: FutureBuilder<AllSongs>(
        future: futureSongs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.songs == null ||
              snapshot.data!.songs!.isEmpty) {
            return const Center(child: Text('No songs found'));
          } else {
            final songs = snapshot.data!.songs!;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => navigateToExample(song, index, songs),
                          child: Hero(
                            tag: song.imageUrl,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                song.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.songName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.tags.join(', '),
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.favorite,
                                    size: 14, color: Colors.red),
                                const SizedBox(width: 4),
                                Text('${song.likes}',
                                    style: const TextStyle(fontSize: 10)),
                                const SizedBox(width: 10),
                                const Icon(Icons.visibility, size: 14),
                                const SizedBox(width: 4),
                                Text('${song.views}',
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
