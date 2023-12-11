import 'package:flutter/material.dart';
import 'package:orange_player/src/components/snackbar.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

class AddToPlaylist extends StatefulWidget {
  const AddToPlaylist({
    super.key,
  });

  static const routeName = '/add_to_playlist';
  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  @override
  Widget build(BuildContext context) {
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);

    List<MyPlaylistModel> playlists = playlistProvider.playlistList;

    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String selectedSongId = arguments["id"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose playlist"),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.save),
        //   ),
        // ],
      ),
      body: ListView.separated(
        itemBuilder: (itemBuilder, index) => ListTile(
          title: Text(playlists[index].name),
          onTap: () {
            playlistProvider.addSongToPlaylist(
              playlistId: playlists[index].id.toString(),
              songId: selectedSongId,
            );
            Navigator.pop(context, playlists[index]);
            SnackbarComponent.showSuccessSnackbar(
              context,
              "Song added to playlist ${playlists[index].name}",
            );
          },
        ),
        separatorBuilder: (itemBuilder, index) => const SizedBox.shrink(),
        itemCount: playlists.length,
      ),
    );
  }
}
