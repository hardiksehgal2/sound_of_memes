import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ventures/MusicScreen/example.dart';
import 'package:ventures/models/all_songs.dart';
import 'package:ventures/models/liked_songs.dart';
import 'package:http/http.dart' as http;

class LikedSongsList extends StatefulWidget {
  const LikedSongsList({super.key});

  @override
  State<LikedSongsList> createState() => _LikedSongsListState();
}

class _LikedSongsListState extends State<LikedSongsList> {
  int _page = 1;
  List<Song> _songs = [];
  bool _isLoading = false;
  bool _hasMore = true;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _fetchLikedSongs();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchLikedSongs() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final token = await getToken();
    final url = Uri.parse("https://api.soundofmeme.com/likedsongs?page=$_page");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final likedSongs = LikedSongs.fromJson(data);

      if (likedSongs.songs.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _songs.addAll(likedSongs.songs);
          _page++;
        });
      }
    } else {
      print("Failed to load liked songs. Status code: ${response.statusCode}");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToExample(Song song, int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Example(
        songUrl: song.songUrl,
        imageUrl: song.imageUrl,
        title: song.songName,
        artist: song.username,
        allLikedSongs: _songs,  // Pass the correct list of songs
        currentIndex: index, allSongs: [],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Songs'),
      ),
      body: _isLoading
          ? ListView.builder(
              itemCount: 10, // Show 10 shimmer placeholders
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 14,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 14,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width: 30,
                                  height: 14,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                if (index == _songs.length - 1 && _hasMore) {
                  _fetchLikedSongs(); // Load more items when reaching the end of the list
                }

                final song = _songs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          song.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song.songName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('By ${song.username}'),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.green),
                              SizedBox(width: 5),
                              Text('${song.likes}'),
                              SizedBox(width: 15),
                              Icon(Icons.visibility, color: Colors.blue),
                              SizedBox(width: 5),
                              Text('${song.views}'),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => navigateToExample(song, index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
