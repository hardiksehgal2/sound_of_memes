import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MusicScreen/fetch_song_slug.dart';
import 'package:ventures/models/search_songs.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchSongs? _searchResult;
  bool _isLoading = false;
  bool _isNotFound = false;
  Set<int> _likedSongs = {};
  Set<int> _dislikedSongs = {};
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _loadLikedSongs();
    _loaddisLikedSongs();
  }

  Future<void> _loadLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likedSongs = (prefs.getStringList('liked_songs') ?? [])
          .map((e) => int.parse(e))
          .toSet();
    });
  }

  Future<void> _loaddisLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dislikedSongs = (prefs.getStringList('disliked_songs') ?? [])
          .map((e) => int.parse(e))
          .toSet();
    });
  }

  Future<void> _saveLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'liked_songs', _likedSongs.map((e) => e.toString()).toList());
  }

  Future<void> _savedisLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'disliked_songs', _dislikedSongs.map((e) => e.toString()).toList());
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> likeSong(int songId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      print('No token found. Please log in again.');
      return;
    }

    final url = Uri.parse('https://api.soundofmeme.com/like');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'song_id': songId}),
      );

      if (response.statusCode == 200) {
        print('Successfully liked the song.');
        setState(() {
          if (_likedSongs.contains(songId)) {
            _likedSongs.remove(songId);
          } else {
            _likedSongs.add(songId);
            _dislikedSongs.remove(songId);
          }
        });
        _saveLikedSongs();
        _savedisLikedSongs();
      } else {
        print('Failed to like song. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while liking song: $e');
    }
  }

  Future<void> dislikeSong(int songId) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      print('No token found. Please log in again.');
      return;
    }

    final url = Uri.parse('https://api.soundofmeme.com/dislike');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'song_id': songId}),
      );

      if (response.statusCode == 200) {
        print('Successfully disliked the song.');
        setState(() {
          if (_dislikedSongs.contains(songId)) {
            _dislikedSongs.remove(songId);
          } else {
            _dislikedSongs.add(songId);
            _likedSongs.remove(songId);
          }
        });
        _saveLikedSongs();
        _savedisLikedSongs();
      } else {
        print('Failed to dislike song. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while disliking song: $e');
    }
  }

  bool _isLiked(int songId) {
    return _likedSongs.contains(songId);
  }

  bool _isdisLiked(int songId) {
    return _dislikedSongs.contains(songId);
  }

  Future<void> _toggleLike(int songId) async {
    await likeSong(songId); // Toggle like
  }

  Future<void> _toggleDislike(int songId) async {
    await dislikeSong(songId); // Toggle dislike
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _isNotFound = false;
    });

    final slug = _searchController.text;
    final formattedSlug = slug.replaceAll(' ', '-');
    final result = await fetchSongBySlug(formattedSlug);

    setState(() {
      _isLoading = false;
      if (result != null) {
        _searchResult = result[0];
      } else {
        _isNotFound = true;
      }
    });

    print('Search result: $_searchResult');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Songs',
          style: GoogleFonts.pottaOne(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter song name',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isNotFound
                    ? const Center(child: Text('Hey you might have not used the correct name, please check'))
                    : _searchResult != null
                        ? Expanded(
                            child: ListView(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            _searchResult!.imageUrl,
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            height: 400,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _searchResult!.songName,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.favorite,
                                                  size: 24,
                                                  color: _isLiked(_searchResult!.songId) ? Colors.pink : Colors.grey,
                                                ),
                                                onPressed: () => _toggleLike(_searchResult!.songId),
                                              ),
                                              Text(
                                                '${_likedSongs.contains(_searchResult!.songId) ? _searchResult!.likes + (_isLiked(_searchResult!.songId) ? 1 : 0) : _searchResult!.likes}',
                                                style: GoogleFonts.poppins(fontSize: 16),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.thumb_down_alt,
                                                  size: 24,
                                                  color: _isdisLiked(_searchResult!.songId) ? Colors.blue : Colors.grey,
                                                ),
                                                onPressed: () => _toggleDislike(_searchResult!.songId),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${_searchResult!.views}',
                                                style: GoogleFonts.poppins(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Optionally display lyrics here
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }
}
