import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Home13 extends StatelessWidget {
  final String telegramUrl = 'https://t.me/SoundOfMeme'; // Replace with actual URL
  final String twitterUrl = 'https://twitter.com/SoundOfMemeSol'; // Replace with actual URL

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cloud image at the top
          Image.asset('assets/images/cloud.png'),
          const SizedBox(height: 100),

          
          // const Expanded(child: SizedBox()), // Pushes content to bottom
          
          // Follow us section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
            '\Follow us here',
            style: GoogleFonts.pottaOne(
              fontSize: 54,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 60),
              
            ],
          ),
         Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          const SizedBox(height: 200),

             GestureDetector(
                onTap: () => _launchURL(telegramUrl),
                child: SvgPicture.asset('assets/images/telegram_icon.svg', width: 54, height: 54),
              ),
              const SizedBox(width: 60),
              GestureDetector(
                onTap: () => _launchURL(twitterUrl),
                child: SvgPicture.asset('assets/images/twitter_icon.svg', width: 54, height: 54),
              ),
          ],
         ),
          
          const SizedBox(height: 20),
          
          // Logo image (replace with actual asset path)
          // Image.asset('assets/logo.png', width: 100, height: 100),
          
          const SizedBox(height: 20),
          
          // Navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {/* Add navigation logic */},
                child: const Text('About', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {/* Add navigation logic */},
                child: const Text('How to buy', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {/* Add navigation logic */},
                child: const Text('Tokenomics', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {/* Add navigation logic */},
                child: const Text('Roadmap', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle the error, for example by showing a snackbar or dialog
      print('Could not launch $url');
    }
  }
}
