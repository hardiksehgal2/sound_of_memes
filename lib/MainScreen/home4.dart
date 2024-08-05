// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Home4 extends StatefulWidget {
  // final ScrollController scrollController;
  const Home4({Key? key}) : super(key: key);

  @override
  State<Home4> createState() => _Home4State();
}

class _Home4State extends State<Home4> {
  double _imageOpacity = 0.0;
  double _imageOffset = 100.0;

  @override
  void initState() {
    super.initState();
    // widget.scrollController.addListener(_scrollListener);
  }

  // void _scrollListener() {
  //   final scrollPosition = widget.scrollController.position.pixels;
  //   final maxScroll = widget.scrollController.position.maxScrollExtent;
  //   final viewportDimension =
  //       widget.scrollController.position.viewportDimension;
  //   final scrollFraction =
  //       (scrollPosition - (maxScroll - viewportDimension)) / viewportDimension;

  //   if (scrollFraction > 0 && scrollFraction <= 1) {
  //     setState(() {
  //       _imageOpacity = scrollFraction;
  //       _imageOffset = 100 * (1 - scrollFraction);
  //     });
  //   } else if (scrollFraction > 1) {
  //     setState(() {
  //       _imageOpacity = 1;
  //       _imageOffset = 0;
  //     });
  //   } else {
  //     setState(() {
  //       _imageOpacity = 0;
  //       _imageOffset = 100;
  //     });
  //   }
  // }

  @override
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/pepe_music.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 220,
                  left: -50,
                  child: Container(
                    height: 100,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cloud4.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0),
                      Text(
                        'MEME \nMusic',
                        style: GoogleFonts.pottaOne(
                          fontSize: 45,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Transforming memes into melodies, SOME is your gateway to sonic innovation!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  right: 0,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cloud3.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  right: 20,
                  child: Container(
                    height: 100,
                    width: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bird_pink.png"),
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
}
  // @override
  // void dispose() {
  //   widget.scrollController.removeListener(_scrollListener);
  //   super.dispose();
  // }
