import 'dart:convert';

class UserSongs {
  final List<Song> songs;

  UserSongs({
    required this.songs,
  });

  factory UserSongs.fromJson(Map<String, dynamic> json) {
    return UserSongs(
      songs: List<Song>.from(json['songs'].map((x) => Song.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songs': List<dynamic>.from(songs.map((x) => x.toJson())),
    };
  }
}

class Song {
  final int songId;
  final String userId;
  final String songName;
  final String songUrl;
  final int likes;
  final int views;
  final String imageUrl;
  final String lyrics;
  final List<String> tags;
  final DateTime dateTime;
  final String slug;
  final String username;

  Song({
    required this.songId,
    required this.userId,
    required this.songName,
    required this.songUrl,
    required this.likes,
    required this.views,
    required this.imageUrl,
    required this.lyrics,
    required this.tags,
    required this.dateTime,
    required this.slug,
    required this.username,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['song_id'],
      userId: json['user_id'],
      songName: json['song_name'],
      songUrl: json['song_url'],
      likes: json['likes'],
      views: json['views'],
      imageUrl: json['image_url'],
      lyrics: json['lyrics'],
      tags: List<String>.from(json['tags'].map((x) => x)),
      dateTime: DateTime.parse(json['date_time']),
      slug: json['slug'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'song_id': songId,
      'user_id': userId,
      'song_name': songName,
      'song_url': songUrl,
      'likes': likes,
      'views': views,
      'image_url': imageUrl,
      'lyrics': lyrics,
      'tags': List<dynamic>.from(tags.map((x) => x)),
      'date_time': dateTime.toIso8601String(),
      'slug': slug,
      'username': username,
    };
  }
}

// Example usage
void main() {
  String jsonString = '''{
      "songs": [
          {
              "song_id": 332,
              "user_id": "hardiksehgal00@gmail.com",
              "song_name": "staying strong",
              "song_url": "https://soundofmeme.s3.amazonaws.com/f1d1b7a1-84a8-4a0a-b464-82fac894ab41.mp3",
              "likes": 0,
              "views": 0,
              "image_url": "https://soundofmeme.s3.amazonaws.com/f1d1b7a1-84a8-4a0a-b464-82fac894ab41.jpeg",
              "lyrics": "I’ve walked through the fire, felt the heat...",
              "tags": [
                  "Rock"
              ],
              "date_time": "2024-08-09 00:38:21",
              "slug": "staying-strong",
              "username": "hardiksehgal00"
          }
      ]
  }''';

  Map<String, dynamic> userSongsMap = json.decode(jsonString);
  UserSongs userSongs = UserSongs.fromJson(userSongsMap);

  print(userSongs.songs[0].songName); // Output: staying strong
}
