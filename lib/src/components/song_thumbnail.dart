import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/theme/padding.dart';

class SongThumbnail extends StatelessWidget {
  final SongModel? currentSong;
  final double? width;
  final OnAudioQuery? controller;

  const SongThumbnail(
      {super.key, required this.currentSong, this.controller, this.width});

  @override
  Widget build(BuildContext context) {
    double width = this.width ?? 50;

    if (currentSong == null) return const SizedBox.shrink();

    return QueryArtworkWidget(
      controller: controller,
      quality: 100,
      artworkBorder: BorderRadius.circular(2),
      artworkClipBehavior: Clip.antiAliasWithSaveLayer,
      artworkFit: BoxFit.cover,
      artworkHeight: width - CONTAINER_PADDING * 2,
      nullArtworkWidget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Image.network(
          'https://files.readme.io/f2e91bb-portalDocs-sonosApp-defaultArtAlone.png',
          width: width - CONTAINER_PADDING * 2,
          fit: BoxFit.cover,
        ),
      ),
      id: currentSong!.id,
      type: ArtworkType.AUDIO,
      artworkWidth: width - CONTAINER_PADDING * 2,
    );
  }
}
