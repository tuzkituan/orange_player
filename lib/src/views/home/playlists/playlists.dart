import 'package:flutter/material.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/playlist_item.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:provider/provider.dart';

class Playlists extends StatefulWidget {
  const Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);

    MyPlaylistModel likedPlaylist = playerProvider.likedPlaylist;

    return Container(
      padding: EdgeInsets.only(
        bottom: PLAYER_BAR_HEIGHT + CONTAINER_PADDING,
        left: COMPONENT_PADDING,
        right: COMPONENT_PADDING,
      ),
      child: Stack(
        children: [
          GridView.count(
            physics: const AlwaysScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: COMPONENT_PADDING,
            mainAxisSpacing: COMPONENT_PADDING,
            padding: EdgeInsets.zero,
            children: [
              PlaylistItem(
                playlist: likedPlaylist,
              ),
            ],
          )
        ],
      ),
    );
  }
}
