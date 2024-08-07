import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MainScreen/scroll_home.dart';
import 'package:ventures/Utils/colors.dart';

class OTPVerificationScreen extends StatefulWidget {
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool _isVerifying = false;

  Future<void> _verifyOTP() async {
    setState(() {
      _isVerifying = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');

    final url = Uri.parse('https://api.soundofmeme.com/verify');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $sessionToken',
      },
      body: jsonEncode(<String, String>{
        'otp': _otpController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access_token'];

      await prefs.setString('access_token', accessToken);
      await prefs.setBool('isSignedIn', true);

      setState(() {
        _isVerifying = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScrollableHome()),
      );
    } else {
      setState(() {
        _isVerifying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${response.body}')),
      );
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isVerifying = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');

    final url = Uri.parse('https://api.soundofmeme.com/sendotp');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $sessionToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isVerifying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    } else {
      setState(() {
        _isVerifying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend OTP: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Verify your email",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pottaOne(
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                    color: textColor1,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Enter the OTP sent to your email",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 20, color: textColor2, height: 1.2),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter OTP",
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 19,
                    ),
                  ),
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _verifyOTP,
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: _isVerifying
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Verify OTP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _resendOTP,
                  child: Center(
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: Colors.blue)
                        : Text(
                            "Resend OTP",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
