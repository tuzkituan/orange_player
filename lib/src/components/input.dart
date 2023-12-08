import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final bool? autofocus;

  final String label;

  const Input({
    Key? key,
    required this.label,
    this.controller,
    this.onChanged,
    this.autofocus,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
        // filled: true,
        label: Text(label),
        // fillColor: Colors.white12,
        // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: hintText,
      ),
      onChanged: onChanged,
    );
  }
}
