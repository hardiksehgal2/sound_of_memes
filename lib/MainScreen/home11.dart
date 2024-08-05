import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class Home11 extends StatefulWidget {
  @override
  State<Home11> createState() => _Home11State();
}

class _Home11State extends State<Home11> {
  List<bool> _customIcons = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
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
      child: Column(
        children: <Widget>[
          Text(
            'MEMES',
            style: GoogleFonts.pottaOne(
              fontSize: 54,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(milliseconds: 1000),
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 2.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            ),
            items: [
              'assets/images/pepe_dj.png',
              'assets/images/pepe_calm.png',
              'assets/images/pepe_god.gif',
              'assets/images/pepe_drink.png',
              'assets/images/pepe_music.png',
            ]
                .map((item) => Container(
                      child: Center(
                        child: Image.asset(item, fit: BoxFit.contain, width: 1000),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(
            height: 60,
          ),
          Text(
            'FAQ',
            style: GoogleFonts.pottaOne(
              fontSize: 54,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildExpansionTile(
                    title: 'What chain is \$SOME on?',
                    content: '\$SOME runs on SOLANA (\$SOL)',
                    isExpanded: _customIcons[0],
                    onExpansionChanged: (bool expand) {
                      setState(() => _customIcons[0] = expand);
                    },
                  ),
                  _buildExpansionTile(
                    title: 'What is the price of \$SOME?',
                    content: '23.08.2024 at 12AM UTC',
                    isExpanded: _customIcons[1],
                    onExpansionChanged: (bool expand) {
                      setState(() => _customIcons[1] = expand);
                    },
                  ),
                  _buildExpansionTile(
                    title: 'When is the Presale?',
                    content:
                        'Yes! Its all about how fast you invest once the Pre-Sale starts. We divide rewards in three segments: Everyone who sends funds in the first \$1 Million collected (In Solana) receives 15% extra tokens. ﻿Contributors who send funds after the \$2M Solana have been collected, gets 10% extra tokens. ﻿Contributors who invest after 3M have been collected gets 5% extra tokens.',
                    isExpanded: _customIcons[2],
                    onExpansionChanged: (bool expand) {
                      setState(() => _customIcons[2] = expand);
                    },
                  ),
                  _buildExpansionTile(
                    title: 'When is the Token Listing',
                    content: '\$SOME token will be listed & tradeable shortly after the Pre-Sale ends & all tokens have been distributed to Pre-Sale Buyers',
                    isExpanded: _customIcons[3],
                    onExpansionChanged: (bool expand) {
                      setState(() => _customIcons[3] = expand);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '\$ SOME',
            style: GoogleFonts.pottaOne(
              fontSize: 54,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required String content,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            trailing: Icon(
              isExpanded
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_drop_down_circle,
            ),
            children: <Widget>[
              ListTile(
                title: Text(content),
              ),
            ],
            onExpansionChanged: onExpansionChanged,
          ),
        ),
      ),
    );
  }
}
