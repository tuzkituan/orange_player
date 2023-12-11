import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orange_player/src/theme/colors.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final Color? color;
  final Icon? icon;
  final List<Widget>? actions;

  const TitleBar({
    super.key,
    required this.title,
    this.icon,
    this.color,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(
            width: 8,
          ),
        ],
        Text(
          title.toUpperCase(),
          style: GoogleFonts.manrope(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: color ?? Colors.white,
              letterSpacing: 1.5,
            ),
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
