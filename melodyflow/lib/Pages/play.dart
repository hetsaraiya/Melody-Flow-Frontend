import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melodyflow/Models/song.dart';

class PlaySong extends StatefulWidget {
  final Song song;

  const PlaySong({super.key, required this.song});

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  late AudioPlayer player;
  Duration songDuration = Duration.zero;
  bool _isplaying = false;

  @override
  void initState() {
    player = AudioPlayer();
    super.initState();
    _initializePlayer();
    playSong();
  }

  Future<void> _initializePlayer() async {
    try {
      if (!mounted) return;

      songDuration =
          (await player.setUrl(widget.song.songUrl)) ?? Duration.zero;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing player: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load song. Please try again later.'),
          ),
        );
      }
    }
  }

  void playSong() {
    setState(() {
      if (_isplaying) {
        _isplaying = false;
        player.pause();
      } else {
        _isplaying = true;
        player.play();
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                  width: screenWidth * 0.53 * 1.5,
                  height: screenHeight * 0.23 * 1.5,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Transform.scale(
                            scale: 1.4,
                            child: Image.network(
                              widget.song.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 60),
            Text(
              widget.song.title.length > 20
                  ? widget.song.title.substring(0, 15) + '...'
                  : widget.song.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.song.artistName
                  .substring(0, widget.song.artistName.length - 8),
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                double progress = songDuration.inMilliseconds == 0
                    ? 0.0
                    : position.inMilliseconds.toDouble() /
                        songDuration.inMilliseconds.toDouble();

                progress = progress.clamp(0.0, 1.0);

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.blue,
                        inactiveTrackColor: Colors.grey,
                        thumbColor: Colors.blue,
                        overlayColor: Colors.blue.withAlpha(32),
                        trackHeight: 4.0,
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (newProgress) {
                          final newPosition = Duration(
                              milliseconds:
                                  (newProgress * songDuration.inMilliseconds)
                                      .toInt());
                          player.seek(newPosition);
                        },
                        min: 0.0,
                        max: 1.0,
                      ),
                    ),
                    Text(
                      "${position.toString().split('.').first} / ${songDuration.toString().split('.').first}",
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: IconButton(
                icon: _isplaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                iconSize: 50,
                onPressed: playSong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
