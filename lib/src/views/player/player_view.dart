import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:orange_player/src/components/marquee_widget.dart';
import 'package:orange_player/src/components/snackbar.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/providers/playlist_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  static const routeName = '/player';

  IconData getRepeatIcon({required LoopMode loopMode}) {
    switch (loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.all:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
    }
  }

  Color getActiveColor({
    required bool value,
    required bool isDarkMode,
    bool isDisabled = false,
  }) {
    if (isDisabled) return DISABLED_BUTTON_COLOR;
    Color buttonColor = isDarkMode ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
    if (value) {
      return PRIMARY_COLOR;
    } else {
      return buttonColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context);

    // CURRENT SONG, PLAYLIST
    final currentSong = playerProvider.currentSong;

    MyPlaylistModel likedPlaylist = playlistProvider.getLikedPlaylist();
    List<String> favoriteIds = likedPlaylist.songIds;

    MyPlaylistModel? currentPlaylist =
        playlistProvider.getAPlaylist(id: playerProvider.currentPlaylistId);

    bool canNext = playerProvider.audioPlayer.hasNext;
    bool canPrev = playerProvider.audioPlayer.hasPrevious;

    // BOOLEAN
    bool isFavorite = currentSong != null
        ? favoriteIds.contains(currentSong.id.toString())
        : false;
    bool isPlaying = playerProvider.audioPlayer.playing;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    LoopMode loopMode =
        playerProvider.audioPlayer.sequenceState?.loopMode ?? LoopMode.off;
    bool isShuffle =
        playerProvider.audioPlayer.sequenceState?.shuffleModeEnabled ?? false;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Playing from Your Library'.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 1.3,
              ),
            ),
            if (currentPlaylist != null) ...[
              const SizedBox(
                height: 2,
              ),
              Text(
                currentPlaylist.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(CONTAINER_PADDING),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [PRIMARY_COLOR.withOpacity(0.5), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SongThumbnail(
                  currentSong: currentSong,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MarqueeWidget(
                          child: Text(
                            currentSong.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: PRIMARY_COLOR,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (currentSong.artist != null)
                          Text(
                            currentSong.artist!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  IconButton(
                    icon: isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border_outlined),
                    onPressed: () {
                      playlistProvider.setFavorite(
                        songId: currentSong.id.toString(),
                      );
                      SnackbarComponent.showSuccessSnackbar(
                          context,
                          !isFavorite
                              ? "Song added to favorites"
                              : "Song removed from favorites");
                    },
                    color: isFavorite ? PRIMARY_COLOR : DARK_BUTTON_COLOR,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder(
                stream: playerProvider.audioPlayer.positionStream,
                builder: (context, snapshot1) {
                  final Duration duration = snapshot1.hasData
                      ? snapshot1.data as Duration
                      : const Duration(seconds: 0);
                  return StreamBuilder(
                      stream: playerProvider.audioPlayer.bufferedPositionStream,
                      builder: (context, snapshot2) {
                        final Duration bufferedDuration = snapshot2.hasData
                            ? snapshot2.data as Duration
                            : const Duration(seconds: 0);
                        return ProgressBar(
                          progress: duration,
                          total: playerProvider.audioPlayer.duration ??
                              const Duration(seconds: 0),
                          buffered: bufferedDuration,
                          timeLabelLocation: TimeLabelLocation.below,
                          progressBarColor: PRIMARY_COLOR,
                          baseBarColor:
                              isDarkMode ? Colors.grey[900] : Colors.grey[400],
                          bufferedBarColor:
                              isDarkMode ? Colors.grey[900] : Colors.grey[400],
                          thumbColor: isDarkMode ? Colors.white : PRIMARY_COLOR,
                          barHeight: 3,
                          thumbRadius: 5,
                          timeLabelTextStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          timeLabelPadding: 6,
                          onSeek: (duration) async {
                            await playerProvider.audioPlayer.seek(duration);
                          },
                        );
                      });
                }),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  renderMediaButton(
                    icon: Icons.shuffle,
                    onPressed: () {
                      playerProvider.toggleShuffle(value: !isShuffle);
                    },
                    color: getActiveColor(
                      isDarkMode: isDarkMode,
                      value: isShuffle,
                    ),
                    size: 28,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: Icons.skip_previous,
                    onPressed: () {
                      if (canPrev) {
                        playerProvider.previous();
                      }
                    },
                    color: getActiveColor(
                      isDarkMode: isDarkMode,
                      value: false,
                      isDisabled: !canPrev,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: isPlaying ? Icons.pause : Icons.play_arrow,
                    onPressed: () {
                      isPlaying
                          ? playerProvider.pause()
                          : playerProvider.resume();
                    },
                    color: Colors.black,
                    bgColor: Colors.white,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: Icons.skip_next,
                    onPressed: () {
                      if (canNext) {
                        playerProvider.next();
                      }
                    },
                    color: getActiveColor(
                      isDarkMode: isDarkMode,
                      value: false,
                      isDisabled: !canNext,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: getRepeatIcon(loopMode: loopMode),
                    onPressed: () {
                      playerProvider.toggleLoop(
                        currentLoopMode: loopMode,
                      );
                    },
                    color: getActiveColor(
                      isDarkMode: isDarkMode,
                      value: loopMode != LoopMode.off,
                    ),
                    size: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 56,
            ),
          ],
        ),
      ),
    );
  }

  Widget renderMediaButton({
    required IconData icon,
    void Function()? onPressed,
    Color? color,
    Color? bgColor,
    double? size,
  }) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(BORDER_RADIUS),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: bgColor ?? Colors.transparent,
        ),
        child: Icon(
          icon,
          color: color ?? DARK_BUTTON_COLOR,
          size: size ?? 44,
        ),
      ),
    );
  }
}
