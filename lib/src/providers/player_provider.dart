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

  // PlayerProvider() {
  //   audioPlayer.processingStateStream.listen((processingState) {
  //     if (processingState == ProcessingState.ready) {
  //       currentSong = audioPlayer.sequenceState!.currentSource!.tag;
  //       notifyListeners();
  //     }
  //   });
  // }

  void setSongList({List<SongModel> songs = const []}) async {
    if (songList.isEmpty) {
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
    }
  }

  void toggleShuffle({bool value = false}) {
    audioPlayer.setShuffleModeEnabled(value);
    notifyListeners();
  }

  void toggleLoop({LoopMode currentLoopMode = LoopMode.off}) {
    LoopMode nextLoopMode;
    switch (currentLoopMode) {
      case LoopMode.off:
        nextLoopMode = LoopMode.one;
        break;
      case LoopMode.one:
        nextLoopMode = LoopMode.all;
        break;
      case LoopMode.all:
        nextLoopMode = LoopMode.off;
        break;
    }
    audioPlayer.setLoopMode(nextLoopMode);
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
