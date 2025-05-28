import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'GameOverScreen.dart';
import 'PauseScreen.dart';
import 'package:google_fonts/google_fonts.dart';  


class FallingTileData {
  final Color color;
  final int lane;
  final Key key;

  FallingTileData({required this.color, required this.lane})
      : key = ValueKey('$lane-${DateTime.now().millisecondsSinceEpoch}');
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final List<Color> safeColors = [
    const Color.fromARGB(255, 39, 97, 41), // dull green
    const Color.fromARGB(255, 12, 52, 85), // dull blue
    const Color.fromARGB(255, 206, 185, 2), // dull yellow
  ];
  final List<FallingTileData> activeTiles = [];

  final int totalLanes = 3;
  int score = 0;
  int lives = 3;
  bool gameOver = false;
  bool isPaused = false;

  Timer? tileSpawnTimer;
  final Random random = Random();
  List<bool> laneOccupied = [false, false, false];

  @override
  void initState() {
    super.initState();
    startTileSpawner();
  }

  void startTileSpawner() {
    tileSpawnTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (!mounted || gameOver || isPaused) return;
      spawnTile();
    });
  }

  void spawnTile() {
    List<int> freeLanes = [];
    for (int i = 0; i < totalLanes; i++) {
      if (!laneOccupied[i]) freeLanes.add(i);
    }

    if (freeLanes.isEmpty) return;

    int selectedLane = freeLanes[random.nextInt(freeLanes.length)];
    Color color = random.nextDouble() < 0.25
        ? const Color(0xFFB71C1C) // dull red
        : safeColors[random.nextInt(safeColors.length)];

    setState(() {
      laneOccupied[selectedLane] = true;
      activeTiles.add(FallingTileData(color: color, lane: selectedLane));
    });
  }

  void handleTileTap(FallingTileData tile) {
    if (gameOver || isPaused) return;

    setState(() {
      if (tile.color == const Color(0xFFB71C1C)) {
        lives--;
        if (lives <= 0) {
          endGame();
        }
      } else {
        score++;
      }
    });
  }

  void endGame() {
    gameOver = true;
    tileSpawnTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameOverScreen(score: score)),
    );
  }

  void releaseLane(int lane) {
    setState(() {
      laneOccupied[lane] = false;
      activeTiles.removeWhere((tile) => tile.lane == lane);
    });
  }

  Future<void> handlePause() async {
    setState(() => isPaused = true);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PauseScreen()),
    );
    setState(() => isPaused = false);
  }

  @override
  void dispose() {
    tileSpawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final tileWidth = screenWidth / totalLanes;
    final tileHeight = screenHeight / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Score: $score   Lives: $lives',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold, fontSize: 20),
          
        ),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: handlePause,
          ),
        ],
      ),
      body: Stack(
        children: activeTiles
            .map((tile) => FallingTile(
                  key: tile.key,
                  tileData: tile,
                  tileWidth: tileWidth,
                  tileHeight: tileHeight,
                  screenHeight: screenHeight,
                  isPaused: isPaused,
                  score: score,
                  onTap: () => handleTileTap(tile),
                  onEnd: () => releaseLane(tile.lane),
                  vsync: this,
                ))
            .toList(),
      ),
    );
  }
}

class FallingTile extends StatefulWidget {
  final FallingTileData tileData;
  final double tileWidth;
  final double tileHeight;
  final double screenHeight;
  final VoidCallback onTap;
  final VoidCallback onEnd;
  final TickerProvider vsync;
  final bool isPaused;
  final int score;

  const FallingTile({
    super.key,
    required this.tileData,
    required this.tileWidth,
    required this.tileHeight,
    required this.screenHeight,
    required this.onTap,
    required this.onEnd,
    required this.vsync,
    required this.isPaused,
    required this.score,
  });

  @override
  State<FallingTile> createState() => _FallingTileState();
}

class _FallingTileState extends State<FallingTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  Duration get fallDuration {
    int decrease = (widget.score ~/ 5) * 100;
    int base = 3000;
    int ms = (base - decrease).clamp(300, base);
    return Duration(milliseconds: ms);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: widget.vsync,
      duration: fallDuration,
    );

    _animation = Tween<double>(
      begin: -widget.tileHeight,
      end: widget.screenHeight + widget.tileHeight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onEnd();
      }
    });
  }

  @override
  void didUpdateWidget(covariant FallingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.isAnimating && widget.isPaused) {
      _controller.stop();
    } else if (!_controller.isAnimating && !widget.isPaused) {
      _controller.forward();
    }
  }

  void handleTap() {
    widget.onTap();
    widget.onEnd();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.tileData.lane * widget.tileWidth;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: _animation.value,
          width: widget.tileWidth,
          height: widget.tileHeight,
          child: GestureDetector(
            onTap: handleTap,
            child: Container(
              color: widget.tileData.color,
            ),
          ),
        );
      },
    );
  }
}
