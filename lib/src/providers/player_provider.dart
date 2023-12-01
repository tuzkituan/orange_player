import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songList = [];

  int? get currentSongIndex {
    return audioPlayer.currentIndex;
  }

  void setSongList({List<SongModel> songs = const []}) {
    songList = songs;
    notifyListeners();
  }

  void play({required SongModel song}) async {
    notifyListeners();
    var playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      // shuffleOrder: DefaultShuffleOrder(),
      children:
          songList.map((e) => AudioSource.uri(Uri.parse(e.uri!))).toList(),
    );
    int currentIndex = songList.indexOf(song);
    await audioPlayer.setAudioSource(
      playlist,
      initialIndex: currentIndex,
      initialPosition: Duration.zero,
    );
    notifyListeners();
    await audioPlayer.play();
  }

  void resume() async {
    notifyListeners();
    await audioPlayer.play();
  }

  void pause() async {
    notifyListeners();
    await audioPlayer.pause();
  }

  SongModel? getPreviousSong() {
    if (currentSongIndex == 0) {
      return null;
    }
    if (currentSongIndex == null) {
      return null;
    }
    return songList[currentSongIndex! - 1];
  }

  SongModel? getNextSong() {
    if (currentSongIndex == songList.length - 1) {
      return null;
    }
    if (currentSongIndex == null) {
      return null;
    }
    return songList[currentSongIndex! + 1];
  }

  void next() async {
    notifyListeners();
    audioPlayer.seekToNext();
  }

  void previous() async {
    notifyListeners();
    audioPlayer.seekToPrevious();
  }
}
