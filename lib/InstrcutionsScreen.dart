import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A1D0D), // dull red
        title: Text(
          'How to Play',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Welcome to "Don't Touch the Red Tile"!

Instructions:

1. Tap the tiles as quickly as possible.

2. Avoid tapping the red tiles — you will loose a life.

3. Clicking on three red tiles means game over.

4. Use the pause button if you need a break.

5. After the game ends, check your score and compete for the high score on the leaderboard.

Good luck and have fun!
            ''',
            style: GoogleFonts.orbitron(
              fontSize: 18,
              color: Colors.red.shade900,
              height: 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
