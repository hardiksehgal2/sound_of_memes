// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
      child: Stack(
        children: [
          Positioned(
            left: -50,
            top: 20,
            child: Image.asset('assets/images/cloud4.png', width: 150),
          ),
          Positioned(
            right: -50,
            bottom: 20,
            child: Image.asset('assets/images/cloud3.png', width: 150),
          ),
          Center(
            child: Container(
              width: 300,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/divisions.png'),
                  fit: BoxFit.contain, // Adjust the fit as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String percentage) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          percentage,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
