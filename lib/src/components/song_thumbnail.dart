import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:orange_player/src/theme/variables.dart';

class SongThumbnail extends StatelessWidget {
  final dynamic currentSong;
  final double? width;
  final OnAudioQuery? controller;
  final bool? isCircle;

  const SongThumbnail({
    super.key,
    required this.currentSong,
    this.controller,
    this.isCircle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    double width = this.width ?? 50;
    double borderRadius = isCircle == true ? 100 : BORDER_RADIUS;

    if (currentSong == null) return const SizedBox.shrink();

    return QueryArtworkWidget(
      controller: controller,
      quality: 100,
      artworkBorder: BorderRadius.circular(borderRadius),
      artworkClipBehavior: Clip.antiAliasWithSaveLayer,
      artworkFit: BoxFit.cover,
      artworkHeight: width - CONTAINER_PADDING * 2,
      nullArtworkWidget: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Image.asset(
          'assets/images/thumbnail.png',
          width: width - CONTAINER_PADDING * 2,
          fit: BoxFit.cover,
        ),
      ),
      id: int.parse(currentSong!.id.toString()),
      type: ArtworkType.AUDIO,
      artworkWidth: width - CONTAINER_PADDING * 2,
    );
  }
}
