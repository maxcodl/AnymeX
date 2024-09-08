import 'package:aurora/components/common/custom_tile.dart';
import 'package:aurora/pages/user/settings/settings_player.dart';
import 'package:aurora/pages/user/settings/settings_sources.dart';
import 'package:aurora/pages/user/settings/settings_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              IconlyBroken.arrow_left_2,
              size: 30,
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          CustomTile(
            icon: Icons.source,
            title: 'Sources',
            description: 'Switch Sources for Animes and Manga',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SourcesSettingPage()));
            },
          ),
          CustomTile(
            icon: Iconsax.play5,
            title: 'Player (Soon)',
            description: 'Change Video Player Settings',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VideoPlayerSettings()));
            },
          ),
          CustomTile(
            icon: Iconsax.paintbucket5,
            title: 'Theme',
            description: 'Change the app theme',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ThemePage()));
            },
          ),
          CustomTile(
            icon: Icons.language,
            title: 'Language',
            description: 'Change the app language',
            onTap: () {},
          ),
          CustomTile(
            icon: Iconsax.info_circle5,
            title: 'About',
            description: 'About this app',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}