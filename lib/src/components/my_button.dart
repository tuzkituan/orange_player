import 'package:flutter/material.dart';
import 'package:orange_player/src/theme/colors.dart';
import 'package:orange_player/src/theme/variables.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, this.icon, required this.text, this.onPressed});

  final IconData? icon;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white12),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: CONTAINER_PADDING / 2,
              vertical: CONTAINER_PADDING / 4,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(
                width: 10,
              ),
            ],
            Text(
              text,
              style: const TextStyle(
                color: PRIMARY_COLOR,
              ),
            ),
          ],
        ));
  }
}
