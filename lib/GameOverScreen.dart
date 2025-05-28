import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainMenu.dart';
import 'GameScreen.dart';
import 'database_helper.dart';
import 'Leaderboard.dart';

class GameOverScreen extends StatefulWidget {
  final int score;

  const GameOverScreen({super.key, required this.score});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  void initState() {
    super.initState();
    saveScoreToDatabase(widget.score);
  }

  Future<void> saveScoreToDatabase(int score) async {
    try {
      await DatabaseHelper.instance.insertScore(score);
      print('Score saved locally: $score');
    } catch (e) {
      print('Failed to save score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Game Over!',
                style: GoogleFonts.orbitron(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your Score:',
                style: GoogleFonts.orbitron(fontSize: 20),
              ),
              Text(
                '${widget.score}',
                style: GoogleFonts.orbitron(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                 Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const GameScreen()),
);

                  
                },
                child: const Text('Play Again'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LeaderboardScreen(previousScreen: GameOverScreen(score: widget.score))),
    );
                },
                child: const Text('Leaderboard'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                  );
                },
                child: const Text('Main Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
