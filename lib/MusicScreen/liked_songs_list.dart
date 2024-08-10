// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Song> _likesongs = [];
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
          _likesongs.addAll(likedSongs.songs);
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

  void navigateToExample(Song song, int index, List<Song> allSongs) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Example(
        songUrl: song.songUrl,
        imageUrl: song.imageUrl,
        title: song.songName,
        artist: song.username,
        
         allSongs: null, // Pass null if you don't need to use allSongs
        allLikedSongs: _likesongs, // Pass the list of liked songs
        allSearchSongs: null, // Pass null if you don't need to use allSearchSongs
        currentIndex: index,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title:  Text('Liked Songs',style:  GoogleFonts.pottaOne(fontWeight: FontWeight.bold,)),
         backgroundColor: Theme.of(context).colorScheme.background
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
                        contentPadding: const EdgeInsets.all(10),
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
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 14,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(width: 5),
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
          :  ListView.builder(
              itemCount: _likesongs.length,
              itemBuilder: (context, index) {
                if (index == _likesongs.length - 1 && _hasMore) {
                  _fetchLikedSongs(); // Load more items when reaching the end of the list
                }
          
                final likedsong = _likesongs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
                  child: AnimationConfiguration.staggeredGrid(
                              position: _likesongs.length,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: AnimationConfiguration.staggeredGrid(
                              position: _likesongs.length,
                              duration: const Duration(milliseconds: 505),
                              columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      likedsong.imageUrl,
                                      width: 60,
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  title: Text(
                                    likedsong.songName,
                                    style:  GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                                    
                                  ),
                                  
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 9),
                                                
                                      Text('By ${likedsong.username}',style:  GoogleFonts.poppins()),
                                      const SizedBox(height: 9),
                                      Row(
                                        children: [
                                          const Icon(Icons.favorite, color: Colors.pink,size: 15,),
                                          const SizedBox(width: 5),
                                          Text('${likedsong.likes}',style:  GoogleFonts.poppins()),
                                          const SizedBox(width: 15),
                                          const Icon(Icons.visibility, color: Colors.blue,size: 15,),
                                          const SizedBox(width: 5),
                                          Text('${likedsong.views}',style:  GoogleFonts.poppins()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () => navigateToExample(likedsong, index,_likesongs),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
