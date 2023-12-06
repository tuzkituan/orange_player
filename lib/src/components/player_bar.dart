import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/models/playlist_model.dart';
import 'package:orange_player/src/views/player/player_view.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';
import 'package:provider/provider.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    final currentSong = playerProvider.currentSong;

    MyPlaylistModel likedPlaylist = playerProvider.likedPlaylist;
    List<String> favoriteIds = likedPlaylist.songIds;

    bool isPlaying = playerProvider.audioPlayer.playing;
    bool isFavorite = currentSong != null
        ? favoriteIds.contains(currentSong.id.toString())
        : false;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
        onTap: () {
          Navigator.restorablePushNamed(context, PlayerView.routeName);
        },
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              // height: PLAYER_BAR_HEIGHT,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: DARK_COMPONENT_BG,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                // gradient: LinearGradient(
                //   colors: [PRIMARY_COLOR.withOpacity(0.4), Colors.transparent],
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: const [0.0, 1],
                // ),
              ),
              // margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: PLAYER_BAR_HEIGHT,
                    padding: const EdgeInsets.only(
                      left: COMPONENT_PADDING,
                      right: COMPONENT_PADDING,
                      top: 0,
                      bottom: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: SongThumbnail(
                            currentSong: currentSong,
                            isCircle: true,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentSong.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: PRIMARY_COLOR,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              // const SizedBox(
                              //   height: 2,
                              // ),
                              // Text(
                              //   currentSong.artist ?? "Unknown",
                              //   style: const TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w400,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Row(
                          children: [
                            renderMediaButton(
                              icon: isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              onPressed: () {
                                playerProvider.setFavorite(
                                  id: currentSong.id.toString(),
                                );
                              },
                              color: isFavorite
                                  ? PRIMARY_COLOR
                                  : DARK_BUTTON_COLOR,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            renderMediaButton(
                              icon: isPlaying ? Icons.pause : Icons.play_arrow,
                              onPressed: () {
                                isPlaying
                                    ? playerProvider.pause()
                                    : playerProvider.resume();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 1),
                    child: StreamBuilder(
                      stream: playerProvider.audioPlayer.positionStream,
                      builder: (context, snapshot1) {
                        final Duration duration = snapshot1.hasData
                            ? snapshot1.data as Duration
                            : const Duration(seconds: 0);
                        return StreamBuilder(
                          stream:
                              playerProvider.audioPlayer.bufferedPositionStream,
                          builder: (context, snapshot2) {
                            final Duration bufferedDuration = snapshot2.hasData
                                ? snapshot2.data as Duration
                                : const Duration(seconds: 0);
                            return ProgressBar(
                              progress: duration,
                              total: playerProvider.audioPlayer.duration ??
                                  const Duration(seconds: 0),
                              buffered: bufferedDuration,
                              timeLabelPadding: 0,
                              timeLabelLocation: TimeLabelLocation.none,
                              progressBarColor: PRIMARY_COLOR,
                              baseBarColor: isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.grey[400],
                              bufferedBarColor: isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.grey[400],
                              barHeight: 2,
                              thumbRadius: 0,
                              onSeek: (duration) async {
                                await playerProvider.audioPlayer.seek(duration);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget renderMediaButton({
    required IconData icon,
    void Function()? onPressed,
    Color? color,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: bgColor ?? Colors.transparent,
        ),
        child: Icon(
          icon,
          color: color ?? DARK_BUTTON_COLOR,
        ),
      ),
    );
  }
}
