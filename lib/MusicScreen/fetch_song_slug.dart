// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ventures/models/search_songs.dart';
 Future<List<SearchSongs>> fetchSongBySlug(String slug) async {
    final url = 'https://api.soundofmeme.com/getsongbyslug?slug=${slug.replaceAll(' ', '-')}'.trim();
    print('Fetching song with URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Response data: $json');
        // Assuming the API returns a JSON object representing a single song
        final song = SearchSongs.fromJson(json);
        return [song]; // Return as a list containing one song
      } else {
        print('Failed to load song');
        return [];
      }
    } catch (e) {
      print('Error fetching song: $e');
      return [];
    }
  }
