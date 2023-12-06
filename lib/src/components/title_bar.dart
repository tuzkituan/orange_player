import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/variables.dart';

class TitleBar extends StatelessWidget {
  final String title;
  const TitleBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: COMPONENT_PADDING),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
    );
  }
}
