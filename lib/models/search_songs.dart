class SearchSongs {
  final int songId;
  final String userId;
  final String songName;
  final String songUrl;
  final int likes;
  final int views;
  final String imageUrl;
  final String lyrics;
  final List<String> tags;
  final String dateTime;
  final String slug;
  final String username;

  SearchSongs({
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

  factory SearchSongs.fromJson(Map<String, dynamic> json) {
    return SearchSongs(
      songId: json['song_id'],
      userId: json['user_id'],
      songName: json['song_name'],
      songUrl: json['song_url'],
      likes: json['likes'],
      views: json['views'],
      imageUrl: json['image_url'],
      lyrics: json['lyrics'],
      tags: List<String>.from(json['tags']),
      dateTime: json['date_time'],
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
      'tags': tags,
      'date_time': dateTime,
      'slug': slug,
      'username': username,
    };
  }
}
