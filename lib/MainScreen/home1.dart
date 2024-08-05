// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ventures/MusicScreen/mainscreen.dart';

class Home1 extends StatefulWidget {
  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  final String contractAddress = "8wsSG2iG2aYVJ9khHPD1JgzzqpQNVABeXjAtC4baSujZ";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
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
            height: 650,
            child: Stack(
              children: [
                Positioned(
                  top: -80,
                  left: 50,
                  right: 60,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/plane.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 50,
                  right: 60,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.sizeOf(context).width * 1,
                      child: Lottie.asset(
                        'assets/images/clouds.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 50,
                  right: 50,
                  child: Container(
                    height: 180,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/some.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 20,
                  right: 350,
                  child: FadeInLeft(
                    from: 200,
                    child: Container(
                      height: 180,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bird_blue.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 350,
                  right: 20,
                  child: FadeInLeft(
                    from: 200,
                    child: Container(
                      height: 180,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bird_green.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 100,
                  right: 0,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/pepe_god.gif"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cloud.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 380,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Pre-Sale is Live',
                        style: GoogleFonts.pottaOne(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              'Buy Presale',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(
                                () => MainScreen(),
                                transition: Transition.circularReveal,
                                duration: Duration(milliseconds: 1300),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            icon: Image.asset(
                              'assets/images/bird_pink.png', // Add your image path here
                              height: 20,
                              width: 20,
                            ),
                            label: Text(
                              'SOME A.I Music',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Positioned(
                  top: 480,
                  child: Container(
                    height: 75,
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.copy),
                              iconSize: 20,
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: contractAddress));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Text has been copied'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            "Contract Address: "
                                .text
                                .bold
                                .textStyle(GoogleFonts.poppins())
                                .black
                                .make(),
                          ],
                        ),
                        contractAddress.text.bold
                            .textStyle(GoogleFonts.poppins())
                            .green600
                            .make(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 350,
                  right: 0,
                  child: FadeInLeft(
                    from: 200,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bird_pink.png"),
                          fit: BoxFit.contain,
                        ),
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
