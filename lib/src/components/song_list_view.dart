import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class SongListView extends StatefulWidget {
  final List<SongModel>? songs;
  final String? playlistId;
  final void Function({
    required SongModel? song,
    required bool isFavorite,
    required void Function({
      required String songId,
    }) onSetFavorite,
  })? onOpenMenu;

  const SongListView({super.key, this.songs, this.playlistId, this.onOpenMenu});

  @override
  State<SongListView> createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  void displayMenu({
    required SongModel? song,
    required bool isFavorite,
    required void Function({required String songId}) onSetFavorite,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, // set this to true
      backgroundColor: DARK_BG,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .25,
          minChildSize: .25,
          maxChildSize: .25,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  dense: true,
                  leading: Icon(isFavorite == true
                      ? Icons.favorite
                      : Icons.favorite_border_outlined),
                  title: Text(
                    isFavorite ? "Unlike" : "Like",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    onSetFavorite(songId: song!.id.toString());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  leading: const Icon(Icons.add),
                  title: const Text(
                    'Add to playlist',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);
    final currentSong = playerProvider.currentSong;

    MyPlaylistModel likedPlaylist = playlistProvider.getLikedPlaylist();
    List<String> favoriteIds = likedPlaylist.songIds;

    void Function({required String songId}) onSetFavorite =
        playlistProvider.setFavorite;

    if (widget.songs == null) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: widget.songs!.length,
      itemBuilder: (context, index) {
        bool isSelected = currentSong != null
            ? currentSong.id.toString() == widget.songs![index].id.toString()
            : false;

        bool isFavorite =
            favoriteIds.contains(widget.songs![index].id.toString());

        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ListTile(
            minVerticalPadding: 16,
            dense: true,
            contentPadding: const EdgeInsets.only(
              left: COMPONENT_PADDING,
              right: COMPONENT_PADDING / 2,
              top: 0,
              bottom: 0,
            ),
            title: Text(
              widget.songs![index].title,
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
            //     Text(widget.songs[index].artist ?? "No Artist"),
            // leading: SizedBox(
            //   width: 40,
            //   height: 40,
            //   child: SongThumbnail(
            //     // controller: _audioQuery,
            //     // isCircle: true,
            //     currentSong: widget.songs![index],
            //   ),
            // ),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              playerProvider.play(
                song: widget.songs![index],
                playlistId: widget.playlistId,
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    displayMenu(
                      song: widget.songs![index],
                      isFavorite: isFavorite,
                      onSetFavorite: onSetFavorite,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
