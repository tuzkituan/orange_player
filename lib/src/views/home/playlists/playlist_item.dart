import 'package:flutter/material.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/playlist_details.dart';

class PlaylistItem extends StatelessWidget {
  final MyPlaylistModel playlist;
  const PlaylistItem({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PlaylistDetails.routeName,
          arguments: {
            "id": playlist.id,
          },
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
          color: Colors.white10,
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/thumbnail.png',
              fit: BoxFit.contain,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: COMPONENT_PADDING,
                  vertical: CONTAINER_PADDING / 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      playlist.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      playlist.songIds.length.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
