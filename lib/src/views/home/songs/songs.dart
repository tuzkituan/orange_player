import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/search_input.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  final bool? hasPermission;
  final Future<void> Function()? pullRefresh;
  final Future<void> Function({bool retry})? checkAndRequestPermissions;

  const Songs({
    super.key,
    this.pullRefresh,
    this.hasPermission,
    this.checkAndRequestPermissions,
  });

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  TextEditingController searchController = new TextEditingController();
  String? searchKey;
  Timer? _debounce;

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchKey = query;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void displayMenu({
    required SongModel? song,
    required bool isFavorite,
    required void Function({required String id}) onSetFavorite,
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
                  leading: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                  ),
                  title: Text(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                  ),
                  onTap: () {
                    onSetFavorite(id: song!.id.toString());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  minVerticalPadding: 0,
                  leading: const Icon(Icons.close),
                  title: const Text('Delete'),
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
    List<SongModel> songList = playerProvider.songList;
    List<String> favoriteIds = playerProvider.favoriteIds;
    void Function({required String id}) onSetFavorite =
        playerProvider.setFavorite;

    final currentSong = playerProvider.audioPlayer.playing
        ? playerProvider.audioPlayer.sequenceState!.currentSource!.tag
        : null;

    double screenHeight = MediaQuery.of(context).size.height;

    List<SongModel> searchedSongList = songList;
    if (searchKey != null) {
      searchedSongList = songList
          .where((element) =>
              element.title.toLowerCase().contains(searchKey!.toLowerCase()))
          .toList();
    }

    return RefreshIndicator(
      onRefresh: widget.pullRefresh!,
      child: ListView(
        padding: EdgeInsets.only(
          // top: CONTAINER_PADDING * 2,
          bottom: PLAYER_BAR_HEIGHT + CONTAINER_PADDING,
        ),
        children: [
          SizedBox(
            height: screenHeight * 0.2,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: screenHeight,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [PRIMARY_COLOR, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.25],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: CONTAINER_PADDING * 2),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: COMPONENT_PADDING,
                        ),
                        child: SearchInput(
                          controller: searchController,
                          onChanged: onSearchChanged,
                        ),
                      ),
                      const SizedBox(
                        height: CONTAINER_PADDING,
                      ),
                      const TitleBar(title: "Songs"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.hasPermission == false
              ? Center(
                  child: noAccessToLibraryWidget(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  itemCount: searchedSongList.length,
                  itemBuilder: (context, index) {
                    bool isSelected = currentSong != null
                        ? currentSong.id.toString() ==
                            searchedSongList[index].id.toString()
                        : false;

                    bool isFavorite = currentSong != null
                        ? favoriteIds.contains(currentSong.id.toString())
                        : false;

                    return ListTile(
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: COMPONENT_PADDING,
                        vertical: 0,
                      ),
                      title: Text(
                        searchedSongList[index].title,
                        style: TextStyle(
                          color: currentSong != null
                              ? isSelected
                                  ? PRIMARY_COLOR
                                  : null
                              : null,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle:
                          Text(searchedSongList[index].artist ?? "No Artist"),
                      leading: SizedBox(
                        width: 44,
                        height: 44,
                        child: SongThumbnail(
                          // controller: _audioQuery,
                          isCircle: true,
                          currentSong: searchedSongList[index],
                        ),
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        playerProvider.play(song: searchedSongList[index]);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          displayMenu(
                            song: searchedSongList[index],
                            isFavorite: isFavorite,
                            onSetFavorite: onSetFavorite,
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: PRIMARY_COLOR,
      ),
      padding: const EdgeInsets.all(CONTAINER_PADDING),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => widget.checkAndRequestPermissions!(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
