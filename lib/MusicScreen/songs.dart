// ignore_for_file: unused_element, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';
// import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';
// import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
// import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ventures/MusicScreen/custom_button';
// import 'package:ventures/MusicScreen/custom_button.dart';
import 'package:ventures/MusicScreen/example.dart';
import 'package:ventures/MusicScreen/search_screen.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/components/my_drawer.dart';
import 'package:ventures/models/all_songs.dart';

class SongScreen extends StatefulWidget {
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  int _page = 1;
  List<Songs> _songs = [];
  bool _isLoading = false;
  bool _hasMore = true;
  Set<int> _likedSongs = {};
  Set<int> _dislikedSongs = {};

  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _fetchSongs();
    _loadLikedSongs();
    _loaddisLikedSongs();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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

  Future<void> _fetchSongs() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://api.soundofmeme.com/allsongs?page=$_page');
      final response = await http.get(url);

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
        // Handle the error here, e.g., display a snackbar or show an error dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load songs. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle the error here, e.g., display a snackbar or show an error dialog
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

  bool _isLiked(int songId) {
    return _likedSongs.contains(songId);
  }

  bool _isdisLiked(int songId) {
    return _dislikedSongs.contains(songId);
  }

  Future<void> _toggleLike(int songId) async {
    if (_isLiked(songId)) {
      await likeSong(songId); // Toggle like off
    } else {
      await likeSong(songId);
    }
  }

  Future<void> _toggleDislike(int songId) async {
    if (_isdisLiked(songId)) {
      await dislikeSong(songId); // Toggle dislike off
    } else {
      await dislikeSong(songId);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MySplashScreen()),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Logout',style: GoogleFonts.pottaOne(
          fontSize: 18,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),),
        content:  Text('Do you want to logout?',style: GoogleFonts.poppins(
          fontSize: 18,
        ),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('Cancel',style: GoogleFonts.poppins(
          fontSize: 14,
          color:Theme.of(context).colorScheme.inversePrimary,
        ),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child:  Text('Logout',style: GoogleFonts.poppins(
          fontSize: 14,
          color:Theme.of(context).colorScheme.inversePrimary,
        ),),
          ),
        ],
      ),
    );
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
          "Recent Songs",
          textAlign: TextAlign.center,
          style: GoogleFonts.pottaOne(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/pepe_calm.png'),
          ),
          onPressed: _showLogoutDialog,
        ),
      ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const MyDrawer(),
      body:
       NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchSongs();
            return true;
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
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
            final liked = _isLiked(song.songId);
            final disliked = _isdisLiked(song.songId);

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageAnimationTransition(
                            page: Example(
                              songUrl: song.songUrl,
                              imageUrl: song.imageUrl,
                              title: song.songName,
                              artist: song.username,
                              allSongs:
                                  _songs, // Pass the correct list of songs
                              currentIndex: index,
                            ),
                            pageAnimationType: BottomToTopFadedTransition(),
                          ),
                        );
                      }, // navigateToExample(song, index, _songs)

                      child: Hero(
                        tag: song.imageUrl,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.network(
                            song.imageUrl,
                            fit: BoxFit.fill,
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
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                size: 14,
                                color: liked ? Colors.pink : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(song.songId),
                            ),
                            // const SizedBox(width: 2),
                            Text(
                                '${_likedSongs.contains(song.songId) ? song.likes + (_isLiked(song.songId) ? 1 : 0) : song.likes}',
                                style: const TextStyle(fontSize: 10)),
                            // const SizedBox(width: 3),
                            IconButton(
                              icon: Icon(
                                Icons.thumb_down_alt,
                                size: 14,
                                color: disliked ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => _toggleDislike(song.songId),
                            ),
                            const SizedBox(width: 2),
                            // Text('${_dislikedSongs.contains(song.songId) ? song.dislikes + (_isdisLiked(song.songId) ? 1 : 0) : song.dislikes}',
                            //     style: const TextStyle(fontSize: 10)),
                            // const SizedBox(width: 10),
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
      ),
      // floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
