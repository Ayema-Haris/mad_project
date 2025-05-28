import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  
import 'Leaderboard.dart';
import 'GameScreen.dart';
import 'InstrcutionsScreen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
         
            SizedBox.expand(
              child: Image.asset(
                'assets/1033.gif',
                fit: BoxFit.cover,
              ),
            ),

            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      'Don\'t Touch the Red Tile',
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                 
                  MainMenuButton(
                    text: 'Start Game',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                  ),
                  MainMenuButton(
                    text: 'Leaderboard',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(previousScreen: MainMenuScreen()),
                        ),
                      );
                    },
                  ),
                  MainMenuButton(
                    text: 'Instructions',
                    onPressed: () {
                       Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InstructionsScreen()),
    );
                    },
                  ),
                  MainMenuButton(
                    text: 'Exit',
                    onPressed: () {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MainMenuButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF7A1D0D), 
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.orbitron(   
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
