import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/snackbar.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/add_to_playlist/add_to_playlist.dart';
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
  void onAddToPlaylist({required String songId}) async {
    Navigator.pushReplacementNamed(
      context,
      AddToPlaylist.routeName,
      arguments: {
        "id": songId,
      },
    );
  }

  void onRemoveFromPlaylist({required String songId}) async {
    if (widget.playlistId != null) {
      PlaylistProvider playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);
      playlistProvider.removeSongFromPlaylist(
          playlistId: widget.playlistId!, songId: songId);
      Navigator.pop(context);
      SnackbarComponent.showSuccessSnackbar(
        context,
        "Song removed from playlist",
        position: FlushbarPosition.BOTTOM,
      );
    }
  }

  void displayMenu({
    required SongModel? song,
    required bool isFavorite,
    required void Function({required String songId}) onSetFavorite,
  }) {
    List<Map<String, dynamic>> menuItems = [
      {
        "title": isFavorite ? "Unlike" : "Like",
        "icon": Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
        ),
        "onTap": () {
          onSetFavorite(songId: song!.id.toString());
          Navigator.pop(context);
          SnackbarComponent.showSuccessSnackbar(
              context,
              !isFavorite
                  ? "Song added to favorites"
                  : "Song removed from favorites");
        }
      },
      {
        "title": "Add to playlist",
        "icon": const Icon(Icons.add),
        "onTap": () {
          onAddToPlaylist(
            songId: song!.id.toString(),
          );
        },
      },
      if (widget.playlistId != null)
        {
          "title": "Remove from playlist",
          "icon": const Icon(Icons.remove),
          "onTap": () {
            onRemoveFromPlaylist(
              songId: song!.id.toString(),
            );
          },
        },
    ];

    double childSize = menuItems.length * 0.12;

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
          initialChildSize: childSize,
          minChildSize: childSize,
          maxChildSize: childSize,
          builder: (BuildContext context, ScrollController scrollController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: menuItems
                  .map(
                    (item) => ListTile(
                      dense: true,
                      leading: item["icon"],
                      title: Text(
                        item["title"],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      onTap: item["onTap"],
                    ),
                  )
                  .toList(),
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
            minVerticalPadding: 12,
            dense: true,
            contentPadding: const EdgeInsets.only(
              left: COMPONENT_PADDING,
              right: COMPONENT_PADDING / 2,
              top: 0,
              bottom: 0,
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: Text(
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
            ),
            subtitle: Text(
              widget.songs![index].artist ?? "No Artist",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            leading: SizedBox(
              width: 44,
              height: 44,
              child: SongThumbnail(
                // controller: _audioQuery,
                isCircle: true,
                currentSong: widget.songs![index],
              ),
            ),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              playerProvider.play(
                song: widget.songs![index],
                playlistId: widget.playlistId,
                playlistProvider: playlistProvider,
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
