import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:simple_music_player/widgets/color_extention.dart';


class Song {
  final String title;
  final String artist;
  final String path1;
  final String imagePath;

  Song({
    required this.title,
    required this.artist,
    required this.path1,
    required this.imagePath,
  });
}

class MusicPlayerScreen extends StatefulWidget {
  final Song song;
  final List<Song> allSongs;
  final int currentIndex;

  const MusicPlayerScreen({super.key, 
    required this.song,
    required this.allSongs,
    required this.currentIndex,
  });

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  int currentIndex = 0;
  bool isRepeating = false;

  @override
  void initState() {
    super.initState();
       widget.allSongs.forEach((song) {
        print("Title: ${song.title}, Path: ${song.path1}");
      });
    _audioPlayer = AudioPlayer();
    currentIndex = widget.currentIndex;
    _setSong(widget.song);

    _audioPlayer.positionStream.listen((position) {
      if (position.inMilliseconds >= _audioPlayer.duration!.inMilliseconds) {
        _nextSongOrStop();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setSong(Song song) async {
    print("All songs:");
   
    print("Setting song: ${song.path1}");
    print("now current index: ${currentIndex} and song path :${song.path1} ");
     // Debug log
    await _audioPlayer.setAsset(song.path1);
    _audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

void skipNext() {
  if (currentIndex < widget.allSongs.length - 1) {
    currentIndex++;
    print("When clicked, current index: $currentIndex");
    _setSong(widget.allSongs[currentIndex]);
  } else {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }
}

  void skipPrevious() {
    if (_audioPlayer.position.inMilliseconds > 3000) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } else {
      if (currentIndex > 0) {
        currentIndex--;
        _setSong(widget.allSongs[currentIndex]);
      }
    }
  }

  void playSongFromQueue(Song song) {
    currentIndex = widget.allSongs.indexOf(song);
    _setSong(song);
  }

  void _nextSongOrStop() {
    if (_audioPlayer.position.inMilliseconds >= _audioPlayer.duration!.inMilliseconds) {
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }
  }

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

  double _clampValue(double value, double min, double max) {
    return value.clamp(min, max);
  }


  

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.allSongs[currentIndex];

    return Scaffold(
        appBar: AppBar(
        backgroundColor: TColor.bg, // Background color for the app bar
        elevation: 0, // Removes the shadow beneath the app bar for a flat look
        title: Text(
          currentSong.title, // Title of the app bar
          style: TextStyle(
            color: Colors.white, // White text color
            fontSize: 20, // Font size of the title
            fontWeight: FontWeight.bold, // Bold font weight for the title
          ),
        ),
        centerTitle: true, // Centers the title in the app bar
      ),
      body: SingleChildScrollView(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 1, 25, 66), Color.fromARGB(255, 157, 2, 246)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                currentSong.imagePath,
                height: 250,
              ),
            ),
            SizedBox(height: 20),
            Text(
              currentSong.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentSong.artist,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final position = positionData?.position ?? Duration.zero;
                final duration = positionData?.duration ?? Duration.zero;

                final minValue = 0.0;
                final maxValue = duration.inMilliseconds.toDouble();
                final currentValue = position.inMilliseconds.toDouble();

                return Slider(
                  thumbColor: TColor.primary,
                  activeColor: TColor.focus,
                  value: _clampValue(currentValue, minValue, maxValue),
                  min: minValue,
                  max: maxValue,
                  onChanged: (newValue) {
                    setState(() {
                      final newPosition = Duration(milliseconds: newValue.round());
                      _audioPlayer.seek(newPosition);
                    });
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  iconSize: 36,
                  onPressed: skipPrevious,
                ),
                IconButton(
                  icon: Icon(isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  iconSize: 64,
                  onPressed: playPause,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  iconSize: 36,
                  onPressed: skipNext,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Song List:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.allSongs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(widget.allSongs[index].imagePath),
                  title: Text(widget.allSongs[index].title),
                  subtitle: Text(widget.allSongs[index].artist),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      playSongFromQueue(widget.allSongs[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
