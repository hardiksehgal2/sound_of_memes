// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MusicScreen/example.dart';
import 'package:ventures/models/all_songs.dart';

class AddSongs extends StatefulWidget {
  @override
  _AddSongsState createState() => _AddSongsState();
}

class _AddSongsState extends State<AddSongs> {
  int _page = 1;
  List<Songs> _songs = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchUserSongs();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchUserSongs() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final token = await getToken();
    if (token == null || token.isEmpty) {
      print('No token found. Please log in again.');
      return;
    }

    try {
      final url = Uri.parse('https://api.soundofmeme.com/usersongs?page=$_page');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final allSongs = AllSongs.fromJson(jsonDecode(response.body));
        if (allSongs.songs.isEmpty) {
          _hasMore = false;
        } else {
          setState(() {
            _songs.addAll(allSongs.songs);
            _page++;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load songs. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while loading songs: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          artist: song.userId,
          allSongs: allSongs,
          currentIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Creations",
          textAlign: TextAlign.center,
          style: GoogleFonts.pottaOne(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: _songs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/guitar.gif"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInRight(
                    child: Text(
                      "No songs in the Playlist",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
              ),
              itemCount: _songs.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _songs.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final song = _songs[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => navigateToExample(song, index, _songs),
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
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.visibility, size: 14),
                                const SizedBox(width: 4),
                                Text('${song.views}',
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
