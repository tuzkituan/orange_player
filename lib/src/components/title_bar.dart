import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/colors.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final Color? color;
  final List<Widget>? actions;

  const TitleBar({
    super.key,
    required this.title,
    this.color,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: color ?? PRIMARY_COLOR,
          ),
        ),
        if (actions != null) ...[
          const SizedBox(
            width: 8,
          ),
          ...actions!
        ]
      ],
    );
  }
}
