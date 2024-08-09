// ignore_for_file: avoid_print

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  late List<Song>? _allLikedSongs;
  late List<Songs>? _allSongs;

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
    _allLikedSongs = widget.allLikedSongs;
    _allSongs = widget.allSongs;
    _updateSongDetails();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    if (_allSongs != null && _allSongs!.isNotEmpty) {
      if (_currentIndex < 0 || _currentIndex >= _allSongs!.length) {
        print('Error: _currentIndex out of range for allSongs.');
        _currentIndex = 0; // Reset to a valid index if needed
      }
      final song = _allSongs![_currentIndex];
      try {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.songUrl)));
      } catch (e) {
        print('Error playing song from allSongs: $e');
      }
    } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
      if (_currentIndex < 0 || _currentIndex >= _allLikedSongs!.length) {
        print('Error: _currentIndex out of range for allLikedSongs.');
        _currentIndex = 0; // Reset to a valid index if needed
      }
      final likedsong = _allLikedSongs![_currentIndex];
      try {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(likedsong.songUrl)));
      } catch (e) {
        print('Error playing song from allLikedSongs: $e');
      }
    } else {
      print('No songs available to play.');
    }
  }

  void _updateSongDetails() {
    if (_allSongs != null && _allSongs!.isNotEmpty) {
      final song = _allSongs![_currentIndex];
      setState(() {
        _songUrl = song.songUrl;
        _imageUrl = song.imageUrl;
        _title = song.songName;
        _artist = song.userId ?? 'Unknown Artist';
      });
    } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
      final likedsong = _allLikedSongs![_currentIndex];
      setState(() {
        _songUrl = likedsong.songUrl;
        _imageUrl = likedsong.imageUrl;
        _title = likedsong.songName;
        _artist = likedsong.userId ?? 'Unknown Artist';
      });
    }
  }

  void _skipToNext() {
    setState(() {
      if (_allSongs != null && _allSongs!.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % _allSongs!.length;
      } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % _allLikedSongs!.length;
      }
      _updateSongDetails();
      _playCurrentSong();
    });
  }

  void _skipToPrevious() {
    setState(() {
      if (_allSongs != null && _allSongs!.isNotEmpty) {
        _currentIndex = (_currentIndex - 1 + _allSongs!.length) % _allSongs!.length;
      } else if (_allLikedSongs != null && _allLikedSongs!.isNotEmpty) {
        _currentIndex = (_currentIndex - 1 + _allLikedSongs!.length) % _allLikedSongs!.length;
      }
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
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
                              size: 500,
                              borderWidth: 4.0,
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
                                    width: 400,
                                    height: 600,
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
                                width: 400,
                                height: 500,
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
                          Theme.of(context).colorScheme.inversePrimary,
                      bufferedBarColor:
                          Theme.of(context).colorScheme.background,
                      progressBarColor: Colors.red,
                      thumbColor: Colors.red,
                      timeLabelTextStyle: TextStyle(
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _artist,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
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
          icon: const Icon(Icons.share, color: Colors.white), // Set icon color
          onPressed: _share,
        ),
        IconButton(
          iconSize: 48, // Increase icon size
          icon: const Icon(Icons.skip_previous,
              color: Colors.white), // Set icon color
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
                icon: const Icon(Icons.play_arrow,
                    color: Colors.white), // Set icon color
                onPressed: () {
                  widget.audioPlayer.play();
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                iconSize: 48, // Increase icon size
                icon: const Icon(Icons.pause,
                    color: Colors.white), // Set icon color
                onPressed: () {
                  widget.audioPlayer.pause();
                },
              );
            }
            return IconButton(
              iconSize: 48, // Increase icon size
              icon: const Icon(Icons.play_arrow,
                  color: Colors.white), // Set icon color
              onPressed: () {
                widget.audioPlayer.seek(Duration.zero);
                widget.audioPlayer.play();
              },
            );
          },
        ),
        IconButton(
          iconSize: 48, // Increase icon size
          icon: const Icon(Icons.skip_next,
              color: Colors.white), // Set icon color
          onPressed: widget.onNext,
        ),
        IconButton(
          iconSize: 20, // Increase icon size
          icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white), // Set icon color
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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
