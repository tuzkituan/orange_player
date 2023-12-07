import 'package:flutter/material.dart';
import 'package:orange_player/src/components/gradient_layout.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/playlist_item.dart';
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

    return GradientLayout(
      color: PRIMARY_COLOR,
      headerChildren: const [
        TitleBar(
          title: "Playlists",
          color: PRIMARY_COLOR,
        ),
      ],
      children: [
        GridView.count(
          physics: const AlwaysScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: COMPONENT_PADDING,
          mainAxisSpacing: COMPONENT_PADDING,
          padding: const EdgeInsets.symmetric(
              horizontal: COMPONENT_PADDING, vertical: 0),
          shrinkWrap: true,
          children: [
            PlaylistItem(
              playlist: likedPlaylist,
            ),
          ],
        )
      ],
    );
  }
}
