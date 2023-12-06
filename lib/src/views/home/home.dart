import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/player_bar.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:orange_player/src/views/home/playlists/playlists.dart';
import 'package:orange_player/src/views/home/settings/settings_controller.dart';
import 'package:orange_player/src/views/home/settings/settings.dart';
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

  Widget renderTitle() {
    String title = '';
    switch (index) {
      case 1:
        title = 'Playlist';
        break;
      case 2:
        title = 'Settings';
        break;
      case 0:
      default:
        title = 'Songs';
        break;
    }

    return TitleBar(title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: renderTitle(),
        surfaceTintColor: Colors.black,
        // scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          if (index == 0)
            SafeArea(
              child: Songs(
                hasPermission: _hasPermission,
                checkAndRequestPermissions: checkAndRequestPermissions,
                pullRefresh: _pullRefresh,
              ),
            ),
          if (index == 1)
            const SafeArea(
              child: Playlists(),
            ),
          if (index == 2)
            SafeArea(
              child: Settings(
                controller: widget.settingsController,
              ),
            ),
          const Positioned(
            left: COMPONENT_PADDING / 4,
            right: COMPONENT_PADDING / 4,
            bottom: COMPONENT_PADDING / 2,
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
          // backgroundColor: Colors.grey[900],
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
