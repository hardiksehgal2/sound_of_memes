// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Screen/otp_verify.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/Utils/colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  bool isFlat = true;
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('https://api.soundofmeme.com/signup2');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'name': _nameController.text,
          'username': _usernameController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final sessionToken = responseData['session_token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_token', sessionToken);

        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OTPVerificationScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

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

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        print("Google sign-in successful");
        print("Name: ${googleUser.displayName}");
        print("Email: ${googleUser.email}");
        print("Profile Picture URL: ${googleUser.photoUrl}");

        var body = jsonEncode({
          "name": googleUser.displayName,
          "email": googleUser.email,
          "picture": googleUser.photoUrl,
        });

        final url = Uri.parse('https://api.soundofmeme.com/googlelogin');
        print("Sending POST request to $url with body: $body");

        var response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: body,
        );

        if (response.statusCode == 200) {
          print("Google login successful");
          final responseData = jsonDecode(response.body);
          final accessToken = responseData['access_token'];
          print('Received access token: $accessToken');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isSignedIn', true);
          await prefs.setString('access_token', accessToken);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScrollableHome()),
          );
        } else {
          print("Google login failed with status code: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google login failed. Please try again.')),
          );
        }
      } else {
        print("Google sign-in cancelled by user");
      }
    } catch (error) {
      print("Error during Google sign-in: $error");
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
            navigator?.push(MaterialPageRoute(
                builder: (context) => const MySplashScreen()));
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
                myTextField(
                    "Enter Username", Colors.white, _usernameController),
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
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
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
                      style: GoogleFonts.poppins(
                          color: Colors.black, // Hint text color
                          fontSize: 13,
                        ),
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
            style: GoogleFonts.poppins(
                          color: Colors.black, // Hint text color
                          fontSize: 19,
                        ),
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
