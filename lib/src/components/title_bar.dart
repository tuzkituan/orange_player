import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/colors.dart';

class TitleBar extends StatelessWidget {
  final String title;
  const TitleBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: PRIMARY_COLOR,
      ),
    );
  }
}
