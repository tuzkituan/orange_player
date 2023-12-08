import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';

class GradientLayout extends StatelessWidget {
  const GradientLayout(
      {super.key,
      this.children,
      this.headerChildren,
      required this.title,
      this.actions,
      this.color});

  final List<Widget>? children;
  final List<Widget>? headerChildren;
  final Color? color;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: TitleBar(title: title),
        backgroundColor: Colors.black45,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        actions: actions,
      ),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: PLAYER_BAR_HEIGHT + CONTAINER_PADDING,
        ),
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: COMPONENT_PADDING,
              right: COMPONENT_PADDING,
              top: CONTAINER_PADDING * 4.5,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? PRIMARY_COLOR).withOpacity(1),
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.9],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (headerChildren != null) ...headerChildren!,
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
