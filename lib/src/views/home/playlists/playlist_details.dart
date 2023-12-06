import 'package:flutter/material.dart';
import 'package:orange_player/src/components/song_list_view.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';

class PlaylistDetails extends StatefulWidget {
  const PlaylistDetails({super.key});

  static const routeName = '/playlist_details';

  @override
  State<PlaylistDetails> createState() => _PlaylistDetailsState();
}

class _PlaylistDetailsState extends State<PlaylistDetails> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    MyPlaylistModel playlist = arguments['playlist'];

    //  PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);

    //   MyPlaylistModel likedPlaylist = playerProvider.likedPlaylist;

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
      ),
      body: SongListView(
        songs: [],
      ),
    );
  }
}
