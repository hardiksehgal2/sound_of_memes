import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventures/MainScreen/home11.dart';
import 'package:ventures/MainScreen/home12.dart';
import 'package:ventures/MainScreen/home13.dart';
import 'package:ventures/Screen/splash_screen.dart';
import 'package:ventures/Themes/theme_provider.dart';
import 'package:ventures/firebase_options.dart';
import 'package:ventures/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup Example',
      theme: Provider.of<ThemeProvider>(context).themeData,
      // home: Home13(),
      home: WelcomeScreen(),
      // getPages: [
      //   GetPage(name: '/', page: () => MySplashScreen()),
      //   GetPage(name: '/signup', page: () => SignUp()),
      //   GetPage(name: '/signIn', page: () => SignIn()),
      //   GetPage(name: '/home', page: () => ScrollableHome()),
      // ],
    );
  }
}
