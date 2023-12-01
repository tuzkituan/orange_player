import 'package:flutter/material.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
