import 'package:flutter/material.dart';
import 'package:orange_player/src/layouts/gradient_layout.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/add_playlist.dart';
import 'package:orange_player/src/views/home/playlists/playlist_item.dart';
import 'package:provider/provider.dart';

class Playlists extends StatefulWidget {
  const Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  void onAddPlaylist() {
    Navigator.restorablePushNamed(context, AddPlaylist.routeName);
  }

  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);

    List<MyPlaylistModel> playlists = playlistProvider.playlistList;

    return GradientLayout(
      color: PRIMARY_COLOR,
      title: "Playlists",
      icon: const Icon(Icons.playlist_add_check_rounded),
      actions: [
        IconButton(
          onPressed: onAddPlaylist,
          iconSize: 24,
          icon: const Icon(Icons.add),
        )
      ],
      children: [
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: COMPONENT_PADDING,
          mainAxisSpacing: COMPONENT_PADDING,
          padding: const EdgeInsets.symmetric(
            horizontal: COMPONENT_PADDING,
            vertical: 0,
          ),
          shrinkWrap: true,
          children: playlists
              .map(
                (playlist) => PlaylistItem(
                  playlist: playlist,
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
