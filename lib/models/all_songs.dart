class AllSongs {
  List<Songs> songs;

  AllSongs({required this.songs});

  factory AllSongs.fromJson(Map<String, dynamic> json) {
    return AllSongs(
      songs: (json['songs'] as List<dynamic>?)
              ?.map((v) => Songs.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songs': songs.map((v) => v.toJson()).toList(),
    };
  }
}

class Songs {
  int songId;
  String userId;
  String songName;
  String songUrl;
  int likes;
  int views;
  String imageUrl;
  String lyrics;
  List<String> tags;
  String dateTime;
  String slug;
  String username;

  Songs({
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

  factory Songs.fromJson(Map<String, dynamic> json) {
    return Songs(
      songId: json['song_id'] as int,
      userId: json['user_id'] as String,
      songName: json['song_name'] as String,
      songUrl: json['song_url'] as String,
      likes: json['likes'] as int,
      views: json['views'] as int,
      imageUrl: json['image_url'] as String,
      lyrics: json['lyrics'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      dateTime: json['date_time'] as String,
      slug: json['slug'] as String,
      username: json['username'] as String,
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
      'tags': tags,
      'date_time': dateTime,
      'slug': slug,
      'username': username,
    };
  }
}