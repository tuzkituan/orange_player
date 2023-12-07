import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/colors.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final Color? color;

  const TitleBar({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 28,
        color: color ?? PRIMARY_COLOR,
      ),
    );
  }
}
