import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_list_view.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class PlaylistDetails extends StatefulWidget {
  const PlaylistDetails({super.key});

  static const routeName = '/playlist_details';

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    MyPlaylistModel? playlist =
        playlistProvider.getAPlaylist(id: arguments["id"]);

    List<SongModel> songs = playlist != null
        ? Provider.of<PlayerProvider>(context).getSongListByIds(
            ids: playlist.songIds,
          )
        : [];

    if (playlist == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          if (playlist.isDeletable == true)
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                playlistProvider.deletePlaylist(id: playlist.id);
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
        ],
      ),
      body: SongListView(
        songs: songs,
        playlistId: playlist.id,
      ),
    );
  }
}
