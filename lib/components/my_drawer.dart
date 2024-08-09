// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/animations/left_to_right_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ventures/MusicScreen/liked_songs_list.dart';
import 'package:ventures/MusicScreen/settings.dart';
import 'package:ventures/models/liked_songs.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: ListTile(
              title: "H O M E".text.make(),
              leading: const Icon(Icons.home),
              onTap: ()=> Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: "S E T T I N G S".text.make(),
              leading: const Icon(Icons.settings),
              onTap: (){ 
                Navigator.pop(context);
Navigator.of(context).push(PageAnimationTransition(page: const SettingsPage(), pageAnimationType: LeftToRightTransition()));

                // Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage(),
                // )
                // );
              },
            ),
          ),
Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 0),
            child: ListTile(
              title: "L I K E D".text.make(),
              leading: const Icon(Icons.settings),
              onTap: (){ 
                Navigator.pop(context);
Navigator.of(context).push(PageAnimationTransition(page: const LikedSongsList(), pageAnimationType: LeftToRightTransition()));
                // Navigator.of(context).push(context, MaterialPageRoute(builder: (context)=> LikedSongsList(),
                // )
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
