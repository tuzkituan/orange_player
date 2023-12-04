import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/components/song_thumbnail.dart';
import 'package:orange_player/src/views/player/player_view.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/padding.dart';
import 'package:provider/provider.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    SongModel? currentSong = playerProvider.currentSong;

    bool isPlaying = playerProvider.audioPlayer.playing;
    // bool canNext = playerProvider.getNextSong() != null;
    // bool canPrevious = playerProvider.getPreviousSong() != null;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        Navigator.restorablePushNamed(context, PlayerView.routeName);
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: DARK_COMPONENT_BG,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                          currentSong != null ? currentSong.title : "Unknown",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          currentSong != null
                              ? currentSong.artist ?? "Unknown"
                              : "Unknown",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Row(
                    children: [
                      renderMediaButton(
                        icon: Icons.favorite_border_outlined,
                        onPressed: () {},
                        color: DARK_BUTTON_COLOR,
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
                      // const SizedBox(
                      //   width: 8.0,
                      // ),
                      // renderMediaButton(
                      //   icon: Icons.skip_next,
                      //   onPressed: () {
                      //     playerProvider.next();
                      //   },
                      //   color: canNext ? BUTTON_COLOR : DISABLED_BUTTON_COLOR,
                      // ),
                    ],
                  )
                ],
              ),
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
