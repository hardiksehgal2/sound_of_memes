// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home8 extends StatefulWidget {
  const Home8({Key? key}) : super(key: key);

  @override
  State<Home8> createState() => _Home8State();
}

class _Home8State extends State<Home8> {
  double _imageOpacity = 0.0;
  double _imageOffset = 100.0;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController = Scrollable.of(context)?.widget.controller;
      _scrollController?.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    final scrollPosition = _scrollController?.position.pixels ?? 0.0;
    final contextPosition =
        context.findRenderObject()?.getTransformTo(null).getTranslation()?.y ?? 0.0;

    if (scrollPosition + MediaQuery.of(context).size.height > contextPosition) {
      setState(() {
        _imageOpacity = 1.0;
        _imageOffset = 0.0;
      });
    } else {
      setState(() {
        _imageOpacity = 0.0;
        _imageOffset = 100.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue[50]!,
            Colors.lightBlue[200]!,
            Colors.lightBlue[400]!,
            Colors.lightBlue[700]!,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(15), // Circular border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Center Text
                Text(
                  'PRESALE DETAILS',
                  style: GoogleFonts.pottaOne(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Middle Center Image
                Image.asset(
                  'assets/images/levels.png',
                  height: 400, // Adjust the height as necessary
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                // Bottom Center Text
                Text(
                  'EARLY \$SOMESTERS GET MORE TOKENS',
                  style: GoogleFonts.pottaOne(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
