// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/Utils/colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  bool isFlat = true;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://143.244.131.156:8000/signup');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'name': _nameController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Set the shared preference to indicate that the user is signed in
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSignedIn', true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MySplashScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${response.body}')),
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
          text: "Sign up with Google",
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
        MaterialPageRoute(builder: (context) => const ScrollableHome()),
      );
    }
  } catch (error) {
    print(error);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In failed. Please try again.')),
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
                MaterialPageRoute(builder: (context) => const MySplashScreen()));
          },
          icon: const Icon(Icons.arrow_back),
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
                    "Welcome back you've\nbeen missed!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 27, color: textColor2, height: 1.2),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                myTextField("Enter Name", Colors.white, _nameController),
                myTextField("Enter Email", Colors.white, _emailController),
                myTextField(
                    "Enter Password", Colors.black26, _passwordController,
                    obscureText: _obscureText),
                const SizedBox(height: 10),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: _signup,
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
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
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _googleSignInButton(),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
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
                    )
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

  Padding myTextField(
      String hint, Color color, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: AnimatedPhysicalModel(
        shadowColor: Colors.black,
        shape: BoxShape.rectangle,
        elevation: isFlat ? 0 : 5,
        color: Colors.white,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
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
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 19,
              ),
              suffixIcon: hint == "Enter Password"
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: color,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
            style: GoogleFonts.poppins(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
