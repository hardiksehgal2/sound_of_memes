// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ventures/MusicScreen/settings.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage(),
                )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
