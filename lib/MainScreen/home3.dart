// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home3 extends StatefulWidget {
  const Home3({Key? key}) : super(key: key);

  @override
  State<Home3> createState() => _Home3State();
}

class _Home3State extends State<Home3> {
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
            Colors.lightBlue[700]!,
            Colors.lightBlue[400]!,
            Colors.lightBlue[200]!,
            Colors.lightBlue[50]!,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: Text(
                      'GET \nSOME',
                      style: GoogleFonts.pottaOne(
                        fontSize: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  FadeInRight(
                    child: Text(
                      'Using our custom music bot we are able to send custom songs for other memes into other crypto communities without getting banned',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: _imageOpacity,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    transform: Matrix4.translationValues(0, _imageOffset, 0),
                    child: Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/pepe_dj.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cloud3.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}
