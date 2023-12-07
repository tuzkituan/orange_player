import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/my_button.dart';
import 'package:orange_player/src/layouts/gradient_layout.dart';
import 'package:orange_player/src/components/search_input.dart';
import 'package:orange_player/src/components/song_list_view.dart';
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
                    onSetFavorite(id: song!.id.toString());
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
    List<SongModel> songList = playerProvider.songList;

    List<SongModel> searchedSongList = songList;
    if (searchKey != null) {
      searchedSongList = songList
          .where((element) =>
              element.title.toLowerCase().contains(searchKey!.toLowerCase()))
          .toList();
    }

    return GradientLayout(
      headerChildren: const [
        TitleBar(title: "Songs"),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: COMPONENT_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchInput(
                controller: searchController,
                onChanged: onSearchChanged,
              ),
              // const SizedBox(
              //   height: COMPONENT_PADDING / 2,
              // ),
              // const Row(
              //   children: [
              //     MyButton(
              //       text: "Play All",
              //       icon: Icons.play_arrow,
              //     ),
              //     SizedBox(
              //       width: 8,
              //     ),
              //     MyButton(
              //       text: "Shuffle",
              //       icon: Icons.shuffle,
              //     ),
              //   ],
              // )
            ],
          ),
        ),
        const SizedBox(
          height: COMPONENT_PADDING,
        ),
        widget.hasPermission == false
            ? Center(
                child: noAccessToLibraryWidget(),
              )
            : SongListView(
                songs: searchedSongList,
                onOpenMenu: displayMenu,
              ),
      ],
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
