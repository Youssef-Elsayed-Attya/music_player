import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    Song(
        songName: 'El Neyya',
        artistName: 'Lege-Cy',
        albumArtImagePath: 'assets/images/2.jpg',
        audioPath:
            'audio/Lege-Cy - El Neyya _ ليجي-سي - النيه (Official Audio).mp3'),
    Song(
        songName: 'Elwa2t Eldaye3',
        artistName: 'Lege-Cy',
        albumArtImagePath: 'assets/images/1.jpg',
        audioPath:
            'audio/Lege-Cy - Elwa2t Eldaye3 _ ليجي سي - الوقت الضايع (Official Audio).mp3'),
    Song(
        songName: 'Cacharal',
        artistName: 'Akher Zapheer',
        albumArtImagePath: 'assets/images/3.jpg',
        audioPath: 'audio/Akher Zapheer - Cacharel اخر زفير - كاشاريل.mp3'),
  ];

  //current playing song index
  int? _currentSongIndex;

  /*

  A U D I O  P L A Y E R
  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position of the song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 3) {
      seek(Duration.zero);
    }
    // if it's within the first 2 seconds of the song, go to the previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it's the first song, loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to durations
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen(
      (newDuration) {
        _totalDuration = newDuration;
        notifyListeners();
      },
    );

    // listen to current duration
    _audioPlayer.onPositionChanged.listen(
      (newPosition) {
        _currentDuration = newPosition;
        notifyListeners();
      },
    );

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /*

  G E T T E R S
  */
  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;

  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;

  Duration get totalDuration => _totalDuration;

  /*

  S E T T E R S
  */
  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    //update the UI
    notifyListeners();
  }
}
