import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistProvider with ChangeNotifier {
  PlaylistProvider() {
    loadFromDisk();
  }

  List<MyPlaylistModel> playlistList = [
    MyPlaylistModel(
      name: 'Liked Songs',
      songIds: [],
      id: 'liked',
      isDeletable: false,
    )
  ];

  void setPlaylist({required String playlistId, required String songId}) {
    MyPlaylistModel find = playlistList.firstWhere(
      (playlist) => playlist.id == playlistId,
    );

    if (find.songIds.contains(songId)) {
      find.songIds.remove(songId);
      // playerProvider.removeFromQueue(songId: songId);
    } else {
      find.songIds.add(songId);
      // playerProvider.addToQueue(songId: songId);
    }

    saveToDisk();
    notifyListeners();
  }

  void setFavorite({required String songId}) {
    MyPlaylistModel find = playlistList.firstWhere(
      (playlist) => playlist.id == 'liked',
    );
    setPlaylist(playlistId: find.id, songId: songId);
  }

  String createPlaylist({required String name, List<String>? songIds}) {
    String id = '${DateTime.now().millisecondsSinceEpoch}';
    playlistList.add(MyPlaylistModel(
      name: name,
      songIds: songIds ?? [],
      id: '${DateTime.now().millisecondsSinceEpoch}',
      isDeletable: true,
    ));
    // notifyListeners();
    saveToDisk();
    return id;
  }

  void deletePlaylist({required String id}) {
    playlistList.removeWhere((playlist) => playlist.id == id);
    saveToDisk();
    notifyListeners();
  }

  void updatePlaylist({required String id, required String name}) {}

  MyPlaylistModel? getAPlaylist({String? id}) {
    if (id == null) {
      return null;
    }
    return playlistList.firstWhereOrNull((playlist) => playlist.id == id);
  }

  MyPlaylistModel getLikedPlaylist() {
    return playlistList.firstWhere((playlist) => playlist.id == "liked");
  }

  void addSongToPlaylist({required String playlistId, required String songId}) {
    MyPlaylistModel find = playlistList.firstWhere(
      (playlist) => playlist.id == playlistId,
    );
    if (find.songIds.contains(songId)) {
      return;
    }
    find.songIds.add(songId);
    saveToDisk();
    notifyListeners();
  }

  void saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = MyPlaylistModel.encode(playlistList);
    prefs.setString('playlistList', encodedData);
    notifyListeners();
  }

  void loadFromDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playlistListString = prefs.getString('playlistList');
    if (playlistListString != null) {
      final List<MyPlaylistModel> decodedData =
          MyPlaylistModel.decode(playlistListString);
      playlistList = decodedData;
    }
    notifyListeners();
  }
}
