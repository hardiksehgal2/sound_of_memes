import 'package:flutter/material.dart';

class SongCreationBottomSheet extends StatefulWidget {
  @override
  _SongCreationBottomSheetState createState() => _SongCreationBottomSheetState();
}

class _SongCreationBottomSheetState extends State<SongCreationBottomSheet> {
  bool isCreateSelected = true;
  List<String> selectedGenres = [];
  final TextEditingController songTitleController = TextEditingController();
  final TextEditingController lyricsController = TextEditingController();
  final TextEditingController genreDescriptionController = TextEditingController();

  final List<String> genres = ['Pop', 'Rock', 'Jazz', 'Blues', 'Classical', 'Country', 'Electronic'];

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
                _buildInputField('Lyrics of your song', lyricsController, maxLines: 5),
              ],
              const SizedBox(height: 10),
              _buildInputField('Genre and description', genreDescriptionController, maxLines: 3),
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

  Widget _buildInputField(String hint, TextEditingController? controller, {int maxLines = 1}) {
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
              labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Implement song creation logic here
        },
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
}