import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home12 extends StatefulWidget {
  const Home12({super.key});

  @override
  State<Home12> createState() => _Home12State();
}

class _Home12State extends State<Home12> {
  List<bool> _customIcons = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          
          
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required String content,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            trailing: Icon(
              isExpanded ? Icons.arrow_upward_rounded : Icons.arrow_drop_down_circle,
            ),
            children: <Widget>[
              ListTile(
                title: Text(content),
              ),
            ],
            onExpansionChanged: onExpansionChanged,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Main Scrollable Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Other widgets returned by the previous classes
            Container(
              height: 200,
              color: Colors.red,
              child: Center(child: Text('Other Content 1')),
            ),
            Container(
              height: 200,
              color: Colors.green,
              child: Center(child: Text('Other Content 2')),
            ),
            // Add the Home12 widget
            Home12(),
          ],
        ),
      ),
    ),
  ));
}
