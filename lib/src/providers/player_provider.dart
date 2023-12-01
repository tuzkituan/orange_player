import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songList = [];
  SongModel? currentSong;
  bool isPlaying = false;

  void setSongList({List<SongModel> songs = const []}) {
    songList = songs;
    notifyListeners();
  }

  void play({required SongModel song}) async {
    currentSong = song;
    String filePath = song.uri!;
    await audioPlayer.setUrl(filePath);
    isPlaying = true;
    notifyListeners();
    await audioPlayer.play();
  }

  void resume() async {
    isPlaying = true;
    notifyListeners();
    await audioPlayer.play();
  }

  void pause() async {
    isPlaying = false;
    notifyListeners();
    await audioPlayer.pause();
  }

  SongModel? getPreviousSong() {
    if (currentSong == null) return null;
    if (songList.indexOf(currentSong!) == 0) {
      return null;
    }
    return songList[songList.indexOf(currentSong!) - 1];
  }

  SongModel? getNextSong() {
    if (currentSong == null) return null;
    if (songList.indexOf(currentSong!) == songList.length - 1) {
      return null;
    }
    return songList[songList.indexOf(currentSong!) + 1];
  }

  void next() async {
    SongModel? nextSong = getNextSong();
    if (nextSong == null) {
      return;
    }
    play(song: nextSong);
    notifyListeners();
  }

  void previous() async {
    SongModel? previousSong = getPreviousSong();
    if (previousSong == null) {
      return;
    }
    play(song: previousSong);
    notifyListeners();
  }
}
