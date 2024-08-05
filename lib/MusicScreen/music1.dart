import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ventures/components/my_drawer.dart';

class Music1 extends StatefulWidget {
  const Music1({super.key});

  @override
  State<Music1> createState() => _Music1State();
}

class _Music1State extends State<Music1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: "P L A Y L I S T".text.makeCentered(),
      ),
      drawer: MyDrawer()
    );
  }
}