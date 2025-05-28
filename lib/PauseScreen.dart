import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'MainMenu.dart';
import 'GameScreen.dart';

class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          SizedBox.expand(
            child: Image.asset(
              'assets/1033.gif',
              fit: BoxFit.cover,
            ),
          ),

          
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Text(
                      'Game Paused',
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
                    text: 'Resume Game',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  
                  MainMenuButton(
                    text: 'Restart Game',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                  ),

                 
                  MainMenuButton(
                    text: 'Exit to Main Menu',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
            textStyle: GoogleFonts.orbitron(  // Changed here
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
