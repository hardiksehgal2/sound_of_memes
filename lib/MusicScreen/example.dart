// ignore_for_file: avoid_print

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ventures/MusicScreen/rotate_border.dart';
import 'package:ventures/models/all_songs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ventures/models/liked_songs.dart';
import 'package:ventures/models/search_songs.dart';

class Example extends StatefulWidget {
  final String songUrl;
  final String imageUrl;
  final String title;
  final String artist;
  final List<Songs>? allSongs;
  final List<SearchSongs>? allSearchSongs;
  final List<Song>? allLikedSongs;
  final int currentIndex;

  const Example({
    Key? key,
    required this.songUrl,
    required this.imageUrl,
    required this.title,
    required this.artist,
    this.allSongs,
    this.allSearchSongs,
    this.allLikedSongs,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;
  late String _songUrl;
  late String _imageUrl;
  late String _title;
  late String _artist;
  late List<Songs>? _allSongs;
  late List<SearchSongs>? _allSearchSongs;
  late List<Song>? _allLikedSongs;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.currentIndex;
    _allSongs = widget.allSongs;
    _allSearchSongs = widget.allSearchSongs;
    _allLikedSongs = widget.allLikedSongs;
    _updateSongDetails();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    // Determine the source of the song
    List<dynamic>? songList;
    if (_allSongs != null && _allSongs!.isNotEmpty) {
      songList = _allSongs;
    } else if (_allSearchSongs != null && _allSearchSongs!.isNotEmpty) {
      songList = _allSearchSongs;
    } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
      songList = _allLikedSongs;
    }

    if (songList == null || songList.isEmpty) {
      print('No songs available to play.');
      return;
    }

    if (_currentIndex < 0 || _currentIndex >= songList.length) {
      print('Error: _currentIndex out of range.');
      _currentIndex = 0; // Reset to a valid index if needed
    }

    final song = songList[_currentIndex];
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.songUrl)));
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void _updateSongDetails() {
    List<dynamic>? songList;
    if (_allSongs != null && _allSongs!.isNotEmpty) {
      songList = _allSongs;
    } else if (_allSearchSongs != null && _allSearchSongs!.isNotEmpty) {
      songList = _allSearchSongs;
    } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
      songList = _allLikedSongs;
    }

    if (songList == null || songList.isEmpty) {
      return;
    }

    final song = songList[_currentIndex];
    setState(() {
      _songUrl = song.songUrl;
      _imageUrl = song.imageUrl;
      _title = song.songName;
      _artist = song.username ?? 'Unknown Artist';
    });
  }

  void _skipToNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % (_allSongs?.length ?? (_allSearchSongs?.length ?? _allLikedSongs!.length));
      _updateSongDetails();
      _playCurrentSong();
    });
  }

  void _skipToPrevious() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + (_allSongs?.length ?? (_allSearchSongs?.length ?? _allLikedSongs!.length))) %
          (_allSongs?.length ?? (_allSearchSongs?.length ?? _allLikedSongs!.length));
      _updateSongDetails();
      _playCurrentSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _title,
          style: GoogleFonts.pottaOne(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.background,    // Deep Purple
        Theme.of(context).colorScheme.primary, // Teal Green
        Theme.of(context).colorScheme.secondary,     // Vivid Violet
        Theme.of(context).colorScheme.inversePrimary,       // Bright Pink
      ],
       begin: Alignment.topCenter,
      end: Alignment.bottomCenter,)
        ),
        // color: Theme.of(context).colorScheme.primary,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<bool>(
                stream: _audioPlayer.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isPlaying
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RotatingBorder(
                              key: const ValueKey("rotatingBorder"),
                              size:
                                  500, // Same size for height and width as the original image
                              borderWidth:
                                  4.0, // Border width for the rotating effect
                              child: Hero(
                                tag: _imageUrl,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    imageUrl: _imageUrl,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.contain,
                                    width: 420, // Width of the image
                                    height: 600, // Height of the image
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Hero(
                            key: const ValueKey("staticImage"),
                            tag: _imageUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                imageUrl: _imageUrl,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.contain,
                                width: 400, // Width of the image
                                height: 500, // Height of the image
                              ),
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ProgressBar(
                      barHeight: 10,
                      baseBarColor:
                          Theme.of(context).colorScheme.primary,
                      bufferedBarColor:
                          Theme.of(context).colorScheme.secondary,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                      progress: positionData?.position ?? Duration.zero,
                      buffered: positionData?.bufferedPosition ?? Duration.zero,
                      total: positionData?.bufferDuration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                _title,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _artist,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Controls(
                audioPlayer: _audioPlayer,
                onNext: _skipToNext,
                onPrevious: _skipToPrevious,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration bufferDuration;

  PositionData(this.position, this.bufferedPosition, this.bufferDuration);
}

class Controls extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Controls({
    Key? key,
    required this.audioPlayer,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  bool _isMuted = false;

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      widget.audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _share() {
    Share.share(
        'Check out this song: ${widget.audioPlayer.sequenceState?.currentSource?.tag}');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 20, // Increase icon size
          icon:  Icon(Icons.share, color: Theme.of(context).colorScheme.background), // Set icon color
          onPressed: _share,
        ),
        IconButton(
          iconSize: 48, // Increase icon size
          icon:  Icon(Icons.skip_previous,
              color: Theme.of(context).colorScheme.background), // Set icon color
          onPressed: widget.onPrevious,
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (playing != true) {
              return IconButton(
                iconSize: 48, // Increase icon size
                icon:  Icon(Icons.play_arrow,
                    color:Theme.of(context).colorScheme.background), // Set icon color
                onPressed: () {
                  widget.audioPlayer.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                iconSize: 48, // Increase icon size
                icon:  Icon(Icons.pause,
                    color: Theme.of(context).colorScheme.background), // Set icon color
                onPressed: () {
                  widget.audioPlayer.pause();
                },
              );
            }
            return IconButton(
              iconSize: 48, // Increase icon size
              icon:  Icon(Icons.play_arrow,
                  color: Theme.of(context).colorScheme.background), // Set icon color
              onPressed: () {
                widget.audioPlayer.seek(Duration.zero);
                widget.audioPlayer.play();
              },
            );
          },
        ),
        IconButton(
          iconSize: 48, // Increase icon size
          icon:  Icon(Icons.skip_next,
              color: Theme.of(context).colorScheme.background), // Set icon color
          onPressed: widget.onNext,
        ),
        IconButton(
          iconSize: 20, // Increase icon size
          icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up,
              color: Theme.of(context).colorScheme.background), // Set icon color
          onPressed: _toggleMute,
        ),
      ],
    );
  }
}

class MediaMetaData extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  const MediaMetaData({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 600, // Adjust height
              width: 400, // Adjust width
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.background,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.background,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}