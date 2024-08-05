import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imagePaths;

  const CustomCarousel({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late CarouselController _carouselController;
  int _currentPage = 0;
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (widget.imagePaths.isNotEmpty) {
        if (_currentPage < widget.imagePaths.length - 1) {
          _carouselController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _carouselController.jumpToPage(0); // Jump to the first page for continuous loop
        }
      }
    });
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    super.dispose(); // No need to dispose the CarouselController
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        options: CarouselOptions(
          height: 200.0,
          viewportFraction: 0.7, // Adjust to control visible part of adjacent images
          autoPlay: false, // Auto-play handled manually
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 300),
          autoPlayCurve: Curves.easeInOut,
          onPageChanged: (index, reason) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index, realIndex) {
          return _buildMemeContainer(widget.imagePaths[index]);
        },
      ),
    );
  }

  Widget _buildMemeContainer(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0), // Margin to show adjacent images
      color: Colors.white,
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}

// Usage example
class Home10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/p1.png',
      'assets/images/p2.png',
      'assets/images/p3.png',
      'assets/images/p4.png',
      'assets/images/p5.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('MEMES'),
        backgroundColor: Colors.blue,
      ),
      body: CustomCarousel(imagePaths: imagePaths),
    );
  }
}
