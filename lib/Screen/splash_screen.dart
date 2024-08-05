// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Screen/sign_in.dart';
import 'package:ventures/Screen/sign_up.dart';
import 'package:ventures/Utils/colors.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool isRegisterExpanded = false;
  bool isSignInExpanded = false;

  @override
  void initState() {
    super.initState();
    // _checkSignInStatus();

    // Reset state when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isRegisterExpanded = false;
        isSignInExpanded = false;
      });
    });
  }
 

//  Future<void> _checkSignInStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isSignedIn = prefs.getBool('isSignedIn') ?? false;

//     await Future.delayed(Duration(seconds: 3));

//     if (isSignedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ScrollableHome()),
//       );
//     // } else {
//     //   Navigator.pushReplacement(
//     //     context,
//     //     MaterialPageRoute(builder: (context) => ScrollableHome()),
//     //   );
//     // }
//   }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: backgroundColor1,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: primaryColor,
                  image: const DecorationImage(
                    image: AssetImage("assets/images/pepe_drink.png"),
                    fit: BoxFit.fill
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.6,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    FadeInUp(
                      from: 150,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Discover here the \n',
                          style: GoogleFonts.pottaOne(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: textColor1,
                            height: 1.2,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'BEST MUSIC ',
                              style: GoogleFonts.pottaOne(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                            // TextSpan(
                            //   text: 'here',
                            //   style: GoogleFonts.pottaOne(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 40,
                            //     color: textColor1,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FadeInUp(
                      from: 150,
                      child: Text(
                        "Explore all the most exciting hit tracks\nbased on your interest and mood",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: textColor2,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: backgroundColor3.withOpacity(0.9),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: size.height * 0.08,
                                width: size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRegisterExpanded = !isRegisterExpanded;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Get.to(() => SignUp(),
                                          transition: Transition.circularReveal,
                                          duration: const Duration(milliseconds: 1300))
                                        ?.then((_) {
                                          // Reset state when returning from SignIn
                                          setState(() {
                                            isRegisterExpanded = false;
                                            isSignInExpanded = false;
                                          });
                                        });
                                    });
                                  },
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 500),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: isRegisterExpanded ? Colors.red : textColor1,
                                        fontSize: isRegisterExpanded ? 30 : 20,
                                      ),
                                      child: const Text("Register"),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08,
                                  width: size.width / 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSignInExpanded = !isSignInExpanded;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 500), () {
                                        Get.to(() => const SignIn(),
                                            transition: Transition.circularReveal,
                                            duration: const Duration(milliseconds: 1300))
                                          ?.then((_) {
                                            // Reset state when returning from SignIn
                                            setState(() {
                                              isRegisterExpanded = false;
                                              isSignInExpanded = false;
                                            });
                                          });
                                      });
                                    },
                                    child: Center(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 500),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: isSignInExpanded ? Colors.red : textColor1,
                                          fontSize: isSignInExpanded ? 30 : 20,
                                        ),
                                        child: const Text("Sign In"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
