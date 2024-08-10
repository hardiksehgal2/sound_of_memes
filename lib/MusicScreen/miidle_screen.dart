// ignore_for_file: avoid_print, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SongCreationBottomSheet extends StatefulWidget {
  @override
  _SongCreationBottomSheetState createState() =>
      _SongCreationBottomSheetState();
}

class _SongCreationBottomSheetState extends State<SongCreationBottomSheet> {
  bool isCreateSelected = true;
  List<String> selectedGenres = [];
  final TextEditingController songTitleController = TextEditingController();
  final TextEditingController lyricsController = TextEditingController();
  final TextEditingController genreDescriptionController =
      TextEditingController();

  final List<String> genres = [
    'Pop',
    'Rock',
    'Jazz',
    'Blues',
    'Classical',
    'Country',
    'Electronic',
    'Dance',
    'Hip Hop',
    'Rap',
    'R&B',
    'Soul',
    'Reggae',
    'EDM',
    'Lo-Fi',
    'Alternative',
    'K-Pop',
    'J-Pop',
    'C-Pop',
    'Afrobeat',
    'Bollywood',
    'Heavy Metal',
    'Thrash Metal',
    'Black Metal',
    'Glitch Hop',
    'Trap',
    'Grime',
    'Folk',
    'Metal',
    'Punk',
    'Funk',
    'Disco',
    'House',
    'Techno',
    'Trance',
    'Dubstep',
    'Drum and Bass',
    'Ambient',
    'Indie',
    'Gospel',
    'Opera',
    'Ska',
    'Grunge',
    'Swing',
    'Bluegrass',
    'Latin',
    'Flamenco',
    'Celtic',
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      snapAnimationDuration: Duration(seconds: 4),
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: const Color(0xFF1E1E1E),
          child: ListView(
            controller: scrollController,
            children: [
              const SizedBox(height: 20),
              _buildToggleButtons(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  isCreateSelected
                      ? 'Describe the mood, theme, and story for your personalized track.'
                      : 'Share your title, lyrics, and choose a genre to shape your song\'s vibe.',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (!isCreateSelected) ...[
                _buildInputField('Song Title', songTitleController),
                const SizedBox(height: 10),
                _buildInputField('Lyrics of your song', lyricsController,
                    maxLines: 5),
              ],
              const SizedBox(height: 10),
              _buildInputField(
                  'Genre and description', genreDescriptionController,
                  maxLines: 3),
              const SizedBox(height: 10),
              _buildGenreChips(),
              const SizedBox(height: 20),
              _buildCreateButton(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('Create', isCreateSelected),
          ),
          Expanded(
            child: _buildToggleButton('Custom Create', !isCreateSelected),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCreateSelected = text == 'Create';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController? controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          fillColor: const Color(0xFF2A2A2A),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (controller == genreDescriptionController) {
            setState(() {}); // Trigger rebuild to update genre chips
          }
        },
      ),
    );
  }

  Widget _buildGenreChips() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: genres.map((genre) {
          bool isSelected = selectedGenres.contains(genre);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected && selectedGenres.length < 5) {
                    selectedGenres.add(genre);
                  } else {
                    selectedGenres.remove(genre);
                  }
                  genreDescriptionController.text = selectedGenres.join(', ');
                });
              },
              backgroundColor: const Color(0xFF2A2A2A),
              selectedColor: const Color(0xFF4CAF50),
              labelStyle:
                  TextStyle(color: isSelected ? Colors.black : Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _createSong() async {
    if (_validateInputs()) {
      final bearerToken = await _getToken();
      if (bearerToken != null) {
        print("Token $bearerToken");

        // Show message and navigate back immediately
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'It might take some time, it will be displayed in My creations',
            style: GoogleFonts.poppins(),
          )),
        );
        Navigator.pop(context); // Navigate back immediately

        // Continue the song creation in the background
        if (isCreateSelected) {
          await createSong(bearerToken);
        } else {
          await customCreateSong(bearerToken);
        }
      } else {
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to create song. Please try again later.')),
        );
      }
    }
  }

  bool _validateInputs() {
    if (!isCreateSelected &&
        (songTitleController.text.isEmpty || lyricsController.text.isEmpty)) {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the song title and lyrics.')),
      );
      return false;
    }
    if (genreDescriptionController.text.isEmpty || selectedGenres.isEmpty) {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one genre.')),
      );
      return false;
    }
    return true;
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: _createSong,
        child: const Text('Create Song', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print('Retrieved token: $token');
    return token;
  }

  Future<void> createSong(String bearerToken) async {
    print('Starting to create song...');
    final url = Uri.parse('https://api.soundofmeme.com/create');

    final body = {
      'song': genreDescriptionController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Song created successfully! Response: ${response.body}');
      } else {
        print('Error creating song: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating song: $e');
    }
  }

  Future<void> customCreateSong(String bearerToken) async {
    print('Starting to custom create song...');
    final url = Uri.parse('https://api.soundofmeme.com/createcustom');

    final body = {
      'title': songTitleController.text,
      'lyric': lyricsController.text,
      'genere': selectedGenres.join(', '),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print('Custom song created successfully! Response: ${response.body}');
      } else {
        print(
            'Error creating custom song: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating custom song: $e');
    }
  }
}
