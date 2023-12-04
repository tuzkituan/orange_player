import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/padding.dart';
import 'package:provider/provider.dart';

class Songs extends StatelessWidget {
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
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    List<SongModel> songList = playerProvider.songList;

    SongModel? currentSong = playerProvider.currentSong;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: pullRefresh!,
        child: hasPermission == false
            ? Center(
                child: noAccessToLibraryWidget(),
              )
            : ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  bool isSelected = currentSong != null
                      ? currentSong.id == songList[index].id
                      : false;
                  return ListTile(
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: COMPONENT_PADDING,
                      vertical: 0,
                    ),
                    title: Text(
                      songList[index].title,
                      style: TextStyle(
                        color: currentSong != null
                            ? isSelected
                                ? Colors.orange
                                : null
                            : null,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(songList[index].artist ?? "No Artist"),
                    leading: SizedBox(
                      width: 48,
                      height: 48,
                      child: SongThumbnail(
                        // controller: _audioQuery,
                        currentSong: songList[index],
                      ),
                    ),
                    onTap: () {
                      playerProvider.play(song: songList[index]);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      padding: const EdgeInsets.all(CONTAINER_PADDING),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions!(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
