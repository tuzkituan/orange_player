import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class SongListView extends StatelessWidget {
  final List<SongModel>? songs;
  final void Function({
    required SongModel? song,
    required bool isFavorite,
    required void Function({required String id}) onSetFavorite,
  })? onOpenMenu;
  const SongListView({super.key, this.songs, this.onOpenMenu});

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    final currentSong = playerProvider.currentSong;

    MyPlaylistModel likedPlaylist = playerProvider.likedPlaylist;
    List<String> favoriteIds = likedPlaylist.songIds;

    void Function({required String id}) onSetFavorite =
        playerProvider.setFavorite;

    if (songs == null) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: songs!.length,
      itemBuilder: (context, index) {
        bool isSelected = currentSong != null
            ? currentSong.id.toString() == songs![index].id.toString()
            : false;

        bool isFavorite = favoriteIds.contains(songs![index].id.toString());

        return ListTile(
          minVerticalPadding: 16,
          dense: true,
          contentPadding: const EdgeInsets.only(
            left: COMPONENT_PADDING,
            right: COMPONENT_PADDING / 2,
            top: 0,
            bottom: 0,
          ),
          title: Text(
            songs![index].title,
            style: TextStyle(
              color: currentSong != null
                  ? isSelected
                      ? PRIMARY_COLOR
                      : null
                  : null,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          // subtitle:
          //     Text(songs[index].artist ?? "No Artist"),
          leading: SizedBox(
            width: 40,
            height: 40,
            child: SongThumbnail(
              // controller: _audioQuery,
              // isCircle: true,
              currentSong: songs![index],
            ),
          ),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            playerProvider.play(song: songs![index]);
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  if (onOpenMenu != null) {
                    onOpenMenu!(
                      song: songs![index],
                      isFavorite: isFavorite,
                      onSetFavorite: onSetFavorite,
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
