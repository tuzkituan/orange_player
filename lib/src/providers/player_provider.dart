import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> songList = [];
  List<SongModel> playingList = [];

  dynamic currentSong;
  String? currentPlaylistId;

  ConcatenatingAudioSource? playlistSequence;

  // PlayerProvider() {
  //   audioPlayer.processingStateStream.listen((processingState) {
  //     if (processingState == ProcessingState.ready) {
  //       currentSong = audioPlayer.sequenceState!.currentSource!.tag;
  //       notifyListeners();
  //     }
  //   });
  // }

  Future<ConcatenatingAudioSource> createNewPlaylistSequence(
      {required List<SongModel> songs}) async {
    return ConcatenatingAudioSource(
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
  }

  List<SongModel> getSongListByIds({required List<String> ids}) {
    return songList.where((song) => ids.contains(song.id.toString())).toList();
  }

  Future<void> startSequence({
    String? playlistId,
    SongModel? song,
    required PlaylistProvider playlistProvider,
  }) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
    List<SongModel>? tempSongList;

    if (playlistId == null) {
      playlist = await createNewPlaylistSequence(songs: songList);
      tempSongList = songList;
    } else {
      MyPlaylistModel? find = playlistProvider.getAPlaylist(
        id: playlistId.toString(),
      );

      if (find != null) {
        tempSongList = find.songIds
            .map(
              (e) => songList.firstWhere(
                (element) => element.id.toString() == e.toString(),
              ),
            )
            .toList();
        playlist = await createNewPlaylistSequence(songs: tempSongList);
      }
    }

    if (tempSongList != null) {
      int currentIndex = song != null
          ? tempSongList.indexWhere(
              (element) => element.id.toString() == song.id.toString())
          : 0;

      await audioPlayer.setAudioSource(
        playlist,
        initialIndex: currentIndex,
        initialPosition: Duration.zero,
      );
      audioPlayer.sequenceStateStream.listen((sequenceState) {
        final currentIndex = sequenceState!.currentIndex;
        currentSong = sequenceState.sequence[currentIndex].tag;
        notifyListeners();
      });
      playlistSequence = playlist;
      playingList = tempSongList;
      notifyListeners();
    }
  }

  void addToQueue({String? songId}) {
    if (songId == null) {
      return;
    }

    if (playlistSequence == null) {
      return;
    }
    SongModel song = songList
        .firstWhere((element) => element.id.toString() == songId.toString());

    playlistSequence!.add(AudioSource.uri(
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
    ));
  }

  void removeFromQueue({String? songId}) {
    if (songId == null) {
      return;
    }

    if (playlistSequence == null) {
      return;
    }

    int index = playlistSequence!.sequence
        .indexWhere((element) => element.tag.id == songId);

    if (index == -1) {
      return;
    }
    playlistSequence!.removeAt(index);
  }

  void setSongList({List<SongModel> songs = const []}) async {
    if (songList.isEmpty) {
      songList = songs;
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
    currentPlaylistId = null;
    audioPlayer.stop();
    notifyListeners();
  }

  void play({
    required SongModel song,
    String? playlistId,
    required PlaylistProvider playlistProvider,
  }) async {
    try {
      bool check = true;

      // PLAY SONG FROM A PLAYLIST
      if (playlistId != null) {
        if (playlistId != currentPlaylistId) {
          currentPlaylistId = playlistId;
          await startSequence(
            playlistId: playlistId,
            song: song,
            playlistProvider: playlistProvider,
          );
        } else {
          check = false;
        }
      }

      // PLAY SONG FROM ALL SONGS
      if (playlistId == null) {
        if (currentPlaylistId == null) {
          currentPlaylistId = "ALL";
          await startSequence(
            song: song,
            playlistProvider: playlistProvider,
          );
        }
        if (currentPlaylistId != null) {
          if (currentPlaylistId == "ALL") {
            check = false;
          } else {
            currentPlaylistId = "ALL";
            await startSequence(
              song: song,
              playlistProvider: playlistProvider,
            );
          }
        }
      }

      if (check == false) {
        int findIndex =
            playingList.indexWhere((element) => element.id == song.id);
        await audioPlayer.seek(Duration.zero, index: findIndex);
      }

      notifyListeners();
      audioPlayer.play();
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
