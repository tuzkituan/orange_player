import 'package:flutter/material.dart';
import 'package:orange_player/src/components/title_bar.dart';
import 'package:orange_player/src/theme/variables.dart';

import 'settings_controller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        padding: EdgeInsets.only(
          top: CONTAINER_PADDING * 2,
          bottom: PLAYER_BAR_HEIGHT + CONTAINER_PADDING,
        ),
        children: [
          const TitleBar(title: "Settings"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: COMPONENT_PADDING),
            child: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ),
        ],
      )
    ]);
  }
}
