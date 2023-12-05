import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/variables.dart';

class TitleBar extends StatelessWidget {
  final List<Widget>? actions;
  final String title;
  const TitleBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: COMPONENT_PADDING),
      margin: const EdgeInsets.only(bottom: COMPONENT_PADDING / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          if (actions != null) ...[const Spacer(), ...actions!]
        ],
      ),
    );
  }
}
