import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class LeaderboardScreen extends StatefulWidget {
  final Widget previousScreen;

  const LeaderboardScreen({super.key, required this.previousScreen});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> scores = [];

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    final allScores = await DatabaseHelper.instance.getAllScores();
    setState(() {
      scores = allScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100, // Dull red background
      appBar: AppBar(
        title: Text('Leaderboard', style: GoogleFonts.orbitron()),
        backgroundColor: Colors.red.shade400,
      ),
      body: scores.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index]['score'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade300,
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    'Score: $score',
                    style: GoogleFonts.orbitron(fontSize: 20),
                  ),
                  trailing: index == 0
                      ? const Text(
                          '🏆 New High Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      : null,
                );
              },
            ),
    );
  }
}
