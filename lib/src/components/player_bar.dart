import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/player/player_view.dart';
import 'package:orange_player/src/providers/player_provider.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:provider/provider.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    List<SongModel> songList = playerProvider.songList;
    int? currentIndex = playerProvider.audioPlayer.currentIndex;
    SongModel? currentSong =
        currentIndex != null ? songList[currentIndex] : null;

    bool isPlaying = playerProvider.audioPlayer.playing;
    bool canNext = playerProvider.getNextSong() != null;
    bool canPrevious = playerProvider.getPreviousSong() != null;

    print("CURRENT SONG: $currentSong");
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
          color: Theme.of(context).brightness == Brightness.dark
              ? DARK_COMPONENT_BG
              : LIGHT_COMPONENT_BG,
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 0,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QueryArtworkWidget(
                    id: currentSong.id,
                    type: ArtworkType.AUDIO,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          currentSong.artist ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
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
                        icon: Icons.skip_previous,
                        onPressed: () {
                          playerProvider.previous();
                        },
                        color:
                            canPrevious ? BUTTON_COLOR : DISABLED_BUTTON_COLOR,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      renderMediaButton(
                        icon: isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: () {
                          isPlaying
                              ? playerProvider.pause()
                              : playerProvider.resume();
                        },
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      renderMediaButton(
                        icon: Icons.skip_next,
                        onPressed: () {
                          playerProvider.next();
                        },
                        color: canNext ? BUTTON_COLOR : DISABLED_BUTTON_COLOR,
                      ),
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

  Widget renderMediaButton(
      {required IconData icon, void Function()? onPressed, Color? color}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Icon(
          icon,
          color: color ?? BUTTON_COLOR,
        ),
      ),
    );
  }
}
