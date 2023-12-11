import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:orange_player/src/theme/colors.dart';

class SnackbarComponent {
  static void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2),
      FlushbarPosition position = FlushbarPosition.TOP}) {
    Flushbar(
      message: message,
      duration: duration,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.GROUNDED,
      animationDuration: const Duration(milliseconds: 400),
    ).show(context);
  }

  static void showSuccessSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2),
      FlushbarPosition position = FlushbarPosition.TOP}) {
    Flushbar(
      message: message,
      duration: duration,
      backgroundColor: PRIMARY_COLOR,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.GROUNDED,
      animationDuration: const Duration(milliseconds: 400),
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    ).show(context);
  }

  static void showErrorSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2),
      FlushbarPosition position = FlushbarPosition.TOP}) {
    Flushbar(
      message: message,
      duration: duration,
      backgroundColor: Colors.red,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.GROUNDED,
      animationDuration: const Duration(milliseconds: 400),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
    ).show(context);
  }
}
