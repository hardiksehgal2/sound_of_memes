import 'package:flutter/material.dart';

class Home6 extends StatelessWidget {
  final ScrollController scrollController;

  const Home6({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue[50]!,
            Colors.lightBlue[200]!,
            Colors.lightBlue[400]!,
            Colors.lightBlue[700]!,
          ],
        ),
      ),
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/web_text.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 115,
              left: 130,
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.28,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/token.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}