import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/player_bar.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/settings/settings_view.dart';
import 'package:provider/provider.dart';

class SongsView extends StatefulWidget {
  const SongsView({super.key});
  static const routeName = '/';

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    bool check = await checkAndRequestPermissions();
    if (check) {
      List<SongModel> songs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      if (!context.mounted) return;
      Provider.of<PlayerProvider>(context, listen: false)
          .setSongList(songs: songs);
    }
  }

  Future<bool> checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
    return _hasPermission;
  }

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    List<SongModel> songList = playerProvider.songList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      songList[index].title,
                      style: TextStyle(
                        color: playerProvider.currentSong != null
                            ? playerProvider.currentSong!.id ==
                                    songList[index].id
                                ? Colors.orange
                                : null
                            : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(songList[index].artist ?? "No Artist"),
                    // trailing: const Icon(Icons.arrow_forward_rounded),
                    // This Widget will query/load image.
                    // You can use/create your own widget/method using [queryArtwork].
                    // leading: QueryArtworkWidget(
                    //   controller: _audioQuery,
                    //   id: songList[index].id,
                    //   type: ArtworkType.AUDIO,
                    // ),
                    onTap: () {
                      playerProvider.play(song: songList[index]);
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: const PlayerBar(),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
