import 'package:flutter/material.dart';
import 'package:orange_player/src/components/input.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  static const routeName = '/add_playlist';

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  TextEditingController nameController = new TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (nameController.text.isNotEmpty) {
      PlaylistProvider playlistProvider =
          Provider.of<PlaylistProvider>(context, listen: false);

      playlistProvider.createPlaylist(name: nameController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new playlist"),
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: COMPONENT_PADDING,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Input(
              controller: nameController,
              label: "Playlist Name",
              autofocus: true,
            )
          ],
        ),
      ),
    );
  }
}
