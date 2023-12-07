import 'package:flutter/material.dart';
import 'package:orange_player/src/views/home/playlists/playlist_details.dart';
import 'package:orange_player/src/views/home/playlists/playlists.dart';

class PlaylistsLayout extends StatefulWidget {
  const PlaylistsLayout({super.key});

  @override
  State<PlaylistsLayout> createState() => _PlaylistsLayoutState();
}

class _PlaylistsLayoutState extends State<PlaylistsLayout> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case PlaylistDetails.routeName:
                return const PlaylistDetails();
              default:
                return const Playlists();
            }
          },
        );
      },
    );
  }
}
