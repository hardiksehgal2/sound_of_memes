import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

class AudioW extends StatefulWidget {
  final String url;
  final String name;

  AudioW({
    Key? key,
    required this.url,
    required this.name,
  }) : super(key: key);

  @override
  _AudioWState createState() => _AudioWState();
}

class _AudioWState extends State<AudioW> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  String _duration = '00:00';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration.toString().split('.').first.substring(2, 7);
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _play(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
    });
  }

  _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _duration = '00:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: <Widget>[
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: .5,
              ),
            ),
            child: FittedBox(
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => _isPlaying ? _pause() : _play(widget.url),
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(_duration),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _stop,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
