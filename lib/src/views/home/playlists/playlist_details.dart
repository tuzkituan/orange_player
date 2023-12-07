import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_list_view.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
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
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    MyPlaylistModel playlist =
        MyPlaylistModel.fromJson(arguments['playlist'] as Map<String, dynamic>);

    List<SongModel> songs = Provider.of<PlayerProvider>(context).songListByIds(
      ids: playlist.songIds,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
      ),
      body: SongListView(
        songs: songs,
      ),
    );
  }
}
