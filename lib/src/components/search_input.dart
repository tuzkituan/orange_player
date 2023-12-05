import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const SearchInput({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        suffixIcon: controller!.text != ''
            ? GestureDetector(
                onTap: () {
                  onChanged!('');
                  controller!.clear();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.transparent,
                  ),
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              )
            : null,
      ),
      // onSubmitted: (String value) {
      //   controller!.text = value;
      //   onFinish!(value);
      // },
      onChanged: onChanged,
    );
  }
}
