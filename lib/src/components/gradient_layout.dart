import 'package:flutter/material.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';

class GradientLayout extends StatelessWidget {
  const GradientLayout(
      {super.key, this.children, required this.headerChildren, this.color});

  final List<Widget>? children;
  final List<Widget> headerChildren;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: ListView(
        padding: EdgeInsets.only(
          bottom: PLAYER_BAR_HEIGHT + CONTAINER_PADDING,
        ),
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: COMPONENT_PADDING,
              right: COMPONENT_PADDING,
              top: CONTAINER_PADDING * 4,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? PRIMARY_COLOR).withOpacity(0.6),
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 1],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...headerChildren,
                const SizedBox(
                  height: COMPONENT_PADDING,
                ),
              ],
            ),
          ),
          if (children != null)
            SafeArea(
              top: false,
              child: Column(
                children: children!,
              ),
            )
        ],
      ),
    );
  }
}
