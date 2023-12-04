import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/padding.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    SongModel? currentSong = playerProvider.currentSong;

    bool isPlaying = playerProvider.audioPlayer.playing;
    bool canNext = playerProvider.getNextSong() != null;
    bool canPrevious = playerProvider.getPreviousSong() != null;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color buttonColor = isDarkMode ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Playing from Library'.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(CONTAINER_PADDING),
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
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          currentSong.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
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
                                  fontSize: 16,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                    ),
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
                          barHeight: 2,
                          thumbRadius: 4,
                          onSeek: (duration) async {
                            await playerProvider.audioPlayer.seek(duration);
                          },
                        );
                      });
                }),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  renderMediaButton(
                    icon: Icons.shuffle,
                    onPressed: () {},
                    color: buttonColor,
                    size: 28,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: Icons.skip_previous,
                    onPressed: () {
                      playerProvider.previous();
                    },
                    color: canPrevious ? buttonColor : DISABLED_BUTTON_COLOR,
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
                      playerProvider.next();
                    },
                    color: canNext ? buttonColor : DISABLED_BUTTON_COLOR,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  renderMediaButton(
                    icon: Icons.repeat_outlined,
                    onPressed: () {},
                    color: buttonColor,
                    size: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 48,
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
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: bgColor ?? Colors.transparent,
        ),
        child: Icon(
          icon,
          color: color ?? DARK_BUTTON_COLOR,
          size: size ?? 36,
        ),
      ),
    );
  }
}
