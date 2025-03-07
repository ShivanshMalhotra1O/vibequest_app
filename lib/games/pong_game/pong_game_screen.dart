import 'package:flutter/material.dart';
import 'dart:async';

class PongGameScreen extends StatefulWidget {
  const PongGameScreen({super.key});

  @override
  PongGameScreenState createState() => PongGameScreenState();
}

class PongGameScreenState extends State<PongGameScreen> {
  double ballX = 0, ballY = 0;
  double ballVelocityX = 0.015, ballVelocityY = 0.015; // Increased ball speed
  double paddleX = 0;
  double paddleWidth = 0.3;
  bool isGameStarted = false;
  double paddleSpeed = 0.2;
  int score = 0;
  Timer? gameTimer;

  void startGame() {
    if (!isGameStarted) {
      isGameStarted = true;
      gameTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          ballX += ballVelocityX;
          ballY += ballVelocityY;

          if (ballX <= -1 || ballX >= 1) {
            ballVelocityX = -ballVelocityX;
          }
          if (ballY <= -1) {
            ballVelocityY = -ballVelocityY;
          }

          if (ballY >= 0.85 && ballX >= paddleX - paddleWidth && ballX <= paddleX + paddleWidth) {
            ballVelocityY = -ballVelocityY;
            score++;
          }

          if (ballY > 1) {
            gameTimer?.cancel();
            isGameStarted = false;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Game Over'),
                content: Text('Your Score: $score'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),
            );
          }
        });
      });
    }
  }

  void movePaddle(double direction) {
    startGame();
    setState(() {
      paddleX += direction * paddleSpeed;
      paddleX = paddleX.clamp(-1.0, 1.0);
    });
  }

  void resetGame() {
    setState(() {
      ballX = 0;
      ballY = 0;
      isGameStarted = false;
      score = 0;
      ballVelocityX = 0.015;
      ballVelocityY = 0.015;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pong Game')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(ballX, ballY),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(paddleX, 0.9),
                    child: Container(
                      width: MediaQuery.of(context).size.width * paddleWidth,
                      height: 10,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Text(
                      'Score: $score',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => movePaddle(-1),
                  child: const Icon(Icons.arrow_left),
                ),
                ElevatedButton(
                  onPressed: () => movePaddle(1),
                  child: const Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
