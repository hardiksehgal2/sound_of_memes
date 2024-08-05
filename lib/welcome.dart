import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Screen/splash_screen.dart'; // Import SplashScreen if needed
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (isSignedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScrollableHome()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MySplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation inside a circular container with black border
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4),
                image: DecorationImage(
                  image: AssetImage("assets/pepe_music.gif"),
                  fit: BoxFit.contain,
                ),
              ),
              // child: ClipOval(
              //   child: Lottie.asset(
              //     'images/pepe_music.json',
              //     fit: BoxFit.contain,
              //   ),
              // ),
            ),
            const SizedBox(height: 20),
            FadeInRight(
              child: Text(
                'Welcome Friends',
                style: GoogleFonts.pottaOne(
                  fontSize: 45,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
