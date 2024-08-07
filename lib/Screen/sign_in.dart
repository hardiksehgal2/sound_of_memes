// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, non_constant_identifier_names, unused_local_variable
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Screen/sign_up.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/Utils/colors.dart';
import 'package:ventures/components/services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseAuth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isFlat = true;
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
  if (_formKey.currentState!.validate()) {
    final url = Uri.parse('https://api.soundofmeme.com/login');
    print("Attempting to sign in with URL: $url");

    var body = jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
    });
    print("Request body: $body");

    try {
      print("Sending request...");
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: body,
      );
      print("Response received. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access_token'];
        print('Received Token: $accessToken');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSignedIn', true);
        await prefs.setString('access_token', accessToken);

        final storedToken = prefs.getString('access_token');
        print('Stored Token: $storedToken');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScrollableHome()),
        );
      } else {
        print("Sign in failed");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign In failed: Incorrect credentials')),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

   Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign in with Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }
   void _handleGoogleSignIn() async {
  try {
    GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
    UserCredential userCredential = await _firebaseAuth.signInWithProvider(_googleAuthProvider);
    if (userCredential.user != null) {
      await _setSignedIn(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScrollableHome()),
      );
    }
  } catch (error) {
    print(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Google Sign-In failed. Please try again.')),
    );
  }
}



  Future<void> _setSignedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', value);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            navigator?.push(
                MaterialPageRoute(builder: (context) => MySplashScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: backgroundColor2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              backgroundColor2,
              backgroundColor2,
              backgroundColor4,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.03),
                FadeInUp(
                  from: 200,
                  child: Text(
                    "Hello Again!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pottaOne(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: textColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SlideInUp(
                  from: 200,
                  child: Text(
                    "Welcome back, you've\nbeen missed!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 27,
                      color: textColor2,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                // for email and password
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: AnimatedPhysicalModel(
                    shadowColor: Colors.black,
                    shape: BoxShape.rectangle,
                    elevation: isFlat ? 0 : 5,
                    color: backgroundColor2,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter email",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black45,
                            fontSize: 19,
                          ),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email should not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: AnimatedPhysicalModel(
                    shadowColor: Colors.black,
                    shape: BoxShape.rectangle,
                    elevation: isFlat ? 0 : 5,
                    color: backgroundColor2,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black45,
                            fontSize: 19,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black26,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password should not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: _signIn,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: size.width * 0.2,
                      color: Colors.black12,
                    ),
                    Text(
                      "  Or continue with   ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: textColor2,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: size.width * 0.2,
                      color: Colors.black12,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _googleSignInButton(),
                  ],
                ),
                SizedBox(height: size.height * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: GoogleFonts.poppins(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "Register now!",
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container socialIcon(String image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Image.asset(
        image,
        height: 35,
      ),
    );
  }
}
