// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MainScreen/home1.dart';
import 'package:ventures/MainScreen/home10.dart';
import 'package:ventures/MainScreen/home11.dart';
import 'package:ventures/MainScreen/home12.dart';
import 'package:ventures/MainScreen/home13.dart';
import 'package:ventures/MainScreen/home2.dart';
import 'package:ventures/MainScreen/home3.dart';
import 'package:ventures/MainScreen/home4.dart';
import 'package:ventures/MainScreen/home5.dart';
import 'package:ventures/MainScreen/home6.dart';
import 'package:ventures/MainScreen/home7.dart';
import 'package:ventures/MainScreen/home8.dart';
import 'package:ventures/MainScreen/home9.dart';
import 'package:ventures/Screen/splash_screen.dart'; 

class ScrollableHome extends StatefulWidget {
  const ScrollableHome({super.key});

  @override
  State<ScrollableHome> createState() => _ScrollableHomeState();
}

class _ScrollableHomeState extends State<ScrollableHome> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

    if (!isSignedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MySplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Home1(),
              Home2(),
              Home3(),
              Home4(),
              Home5(scrollController: _scrollController),
              Home6(scrollController: _scrollController),
              Home7(),
              Home8(),
              Home9(),
              // Home10(),
              Home11(),
              // Home12(),
              Home13()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController1.dispose();
    super.dispose();
  }
}