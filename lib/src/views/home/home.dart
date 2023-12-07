import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/player_bar.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/playlists_layout.dart';
import 'package:orange_player/src/views/home/settings/settings_controller.dart';
import 'package:orange_player/src/views/home/songs/songs.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.settingsController});
  static const routeName = '/';

  final SettingsController settingsController;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  int index = 0;

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

  Future<void> _pullRefresh() async {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          if (index == 0)
            Songs(
              hasPermission: _hasPermission,
              checkAndRequestPermissions: checkAndRequestPermissions,
              pullRefresh: _pullRefresh,
            ),
          if (index == 1) const PlaylistsLayout(),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: PlayerBar(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: PRIMARY_COLOR,
          backgroundColor: Color.fromARGB(255, 22, 22, 22),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: ACCENT_3,
          enableFeedback: false,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          iconSize: 24,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              label: 'Songs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check),
              label: 'Playlists',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings),
            //   label: '',
            // ),
          ],
        ),
      ),
    );
  }
}
