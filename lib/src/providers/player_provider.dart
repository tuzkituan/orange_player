import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/models/playlist_model.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songList = [];

  MyPlaylistModel likedPlaylist = MyPlaylistModel(
    name: 'Liked Songs',
    songIds: [],
    id: 'liked',
  );

  dynamic currentSong;
  int? currentSongIndex;

  LoopMode loopMode = LoopMode.off;
  bool isShuffle = false;

  // PlayerProvider() {
  //   audioPlayer.processingStateStream.listen((processingState) {
  //     if (processingState == ProcessingState.ready) {
  //       currentSong = audioPlayer.sequenceState!.currentSource!.tag;
  //       notifyListeners();
  //     }
  //   });
  // }

  void setSongList({List<SongModel> songs = const []}) async {
    songList = songs;

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: songs
          .map(
            (song) => AudioSource.uri(
              Uri.parse(song.uri!),
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: song.id.toString(),
                // Metadata to display in the notification:
                album: song.album,
                title: song.title,
                artist: song.artist,
                artUri: Uri.parse(song.uri!),
              ),
            ),
          )
          .toList(),
    );
    await audioPlayer.setAudioSource(
      playlist,
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      final currentIndex = sequenceState!.currentIndex;
      currentSong = sequenceState.sequence[currentIndex].tag;
      notifyListeners();
    });
    notifyListeners();
    await audioPlayer.play();
  }

  void toggleShuffle() {
    audioPlayer.setShuffleModeEnabled(!isShuffle);
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void toggleLoop() {
    switch (loopMode) {
      case LoopMode.off:
        loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        loopMode = LoopMode.off;
        break;
    }
    audioPlayer.setLoopMode(loopMode);
    notifyListeners();
  }

  void reset() {
    currentSong = null;
    notifyListeners();
  }

  void setFavorite({required String id}) {
    if (likedPlaylist.songIds.contains(id)) {
      likedPlaylist.songIds.remove(id);
    } else {
      likedPlaylist.songIds.add(id);
    }
    notifyListeners();
  }

  void play({required SongModel song}) async {
    try {
      int findIndex = songList.indexWhere((element) => element.id == song.id);
      await audioPlayer.seek(Duration.zero, index: findIndex);
      notifyListeners();
      await audioPlayer.play();
    } catch (e) {
      reset();
      print(e);
    }
  }

  void resume() async {
    try {
      notifyListeners();
      await audioPlayer.play();
    } catch (e) {
      reset();
      print(e);
    }
  }

  void pause() async {
    notifyListeners();
    await audioPlayer.pause();
  }

  void next() async {
    await audioPlayer.seekToNext();
    notifyListeners();
  }

  void previous() async {
    await audioPlayer.seekToPrevious();
    notifyListeners();
  }
}
