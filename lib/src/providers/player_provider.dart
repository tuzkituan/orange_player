import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songList = [];
  SongModel? currentSong;
  bool isPlaying = false;

  PlayerProvider() {
    audioPlayer.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        next();
      }
    });
  }

  void setSongList({List<SongModel> songs = const []}) {
    songList = songs;
    notifyListeners();
  }

  void reset() {
    currentSong = null;
    isPlaying = false;
    notifyListeners();
  }

  void play({required SongModel song}) async {
    currentSong = song;
    String filePath = song.uri!;
    try {
      await audioPlayer.setUrl(filePath);
      isPlaying = true;
      notifyListeners();
      await audioPlayer.play();
    } catch (e) {
      reset();
      print(e);
    }
  }

  void resume() async {
    try {
      isPlaying = true;
      notifyListeners();
      await audioPlayer.play();
    } catch (e) {
      reset();
      print(e);
    }
  }

  void pause() async {
    isPlaying = false;
    notifyListeners();
    await audioPlayer.pause();
  }

  SongModel? getPreviousSong() {
    try {
      if (currentSong == null) return null;
      if (songList.indexOf(currentSong!) == 0) {
        return null;
      }
      return songList[songList.indexOf(currentSong!) - 1];
    } catch (e) {
      return null;
    }
  }

  SongModel? getNextSong() {
    try {
      if (currentSong == null) return null;
      if (songList.indexOf(currentSong!) == songList.length - 1) {
        return null;
      }
      return songList[songList.indexOf(currentSong!) + 1];
    } catch (e) {
      return null;
    }
  }

  void next() async {
    SongModel? nextSong = getNextSong();
    if (nextSong == null) {
      pause();
      // currentSong = null;
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
