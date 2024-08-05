import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ventures/MainScreen/scroll_home.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    
      
      try{
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) return;

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
      }catch(e){
        print("Error $e");
      }

      // final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // if (userCredential.user != null) {
      //   // Store sign-in status if needed
      //   // await _setSignedIn(true);

      //   // Navigate to the ScrollableHome screen
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => ScrollableHome()), // Replace with your actual home screen widget
      //   );
      }
    
}

