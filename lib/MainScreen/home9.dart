// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home9 extends StatelessWidget {
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
      ),// Light blue color
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width *
              0.85, // Adjust the width as needed
          height: MediaQuery.sizeOf(context).height *
              0.70, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Colors.white, // White color
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GET \$SOME IN 4 SIMPLE STEPS',
                style: GoogleFonts.pottaOne(
                  fontSize: 20, // Adjust font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Heading text color
                ),
              ),
              SizedBox(
                  height: 10), // Add spacing between heading and other text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39.0, vertical: 15),
                child: Text(
                  '1. PREPARE WALLET:Go to the official Phantom wallet website. Download and install it. Securely save your seed phrase (12 words). This step is important to make sure you get your \$SOME tokens.',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust font size
                    color: Colors.black, // Other text color
                  ),
                ),
              ),
              SizedBox(
                  height: 10), // Add spacing between heading and other text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39.0, vertical: 15),
                child: Text(
                  '2. Get SOLANA (\$SOL) & send them to your Phantom wallet. \$SOME is a Solana based coin, so you need some SOL to buy it. And make sure to then send SOL to your Phantom Wallet. Simply use your favorite exchange like:',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust font size
                    color: Colors.black, // Other text color
                  ),
                ),
              ),
              SizedBox(
                  height: 10), // Add spacing between heading and other text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39.0, vertical: 15),
                child: Text(
                  '3. BE FAST AND GET \$SOME : Once the pre-sale is LIVE – send your SOL from your Phantom Wallet to the pre-sale address specified on our website. Be aware of scammers – official address will be posted only on the website.',
                  style: GoogleFonts.poppins(
                    fontSize: 16, // Adjust font size
                    color: Colors.black, // Other text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
