class AllSongs {
  List<Songs>? songs;

  AllSongs({this.songs});

  AllSongs.fromJson(Map<String, dynamic> json) {
    if (json['songs'] != null) {
      songs = <Songs>[]; // Properly initialize the list
      json['songs'].forEach((v) {
        songs?.add(Songs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (songs != null) {
      data['songs'] = songs?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Songs {
  int? songId;
  String? userId;
  String songName;
  String songUrl;
  int likes;
  int views;
  String imageUrl;
  String lyrics;
  List<String> tags;
  String dateTime;

  Songs({
    this.songId,
    this.userId,
    required this.songName,
    required this.songUrl,
    required this.likes,
    required this.views,
    required this.imageUrl,
    required this.lyrics,
    required this.tags,
    required this.dateTime,
  });

  Songs.fromJson(Map<String, dynamic> json)
      : songId = json['song_id'],
        userId = json['user_id'],
        songName = json['song_name'],
        songUrl = json['song_url'],
        likes = json['likes'],
        views = json['views'],
        imageUrl = json['image_url'],
        lyrics = json['lyrics'],
        tags = List<String>.from(json['tags']),
        dateTime = json['date_time'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['song_id'] = songId;
    data['user_id'] = userId;
    data['song_name'] = songName;
    data['song_url'] = songUrl;
    data['likes'] = likes;
    data['views'] = views;
    data['image_url'] = imageUrl;
    data['lyrics'] = lyrics;
    data['tags'] = tags;
    data['date_time'] = dateTime;
    return data;
  }
}