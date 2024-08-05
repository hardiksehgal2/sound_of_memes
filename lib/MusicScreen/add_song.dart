import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSongs extends StatelessWidget {
  const AddSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            "My Creations",
            textAlign: TextAlign.center,
            style: GoogleFonts.pottaOne(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    image:const DecorationImage(
                      image: AssetImage("assets/guitar.gif"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeInRight(
                  child:Text(
          "No songs in the Playlist",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            // color: textColor1,
          ),
        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}