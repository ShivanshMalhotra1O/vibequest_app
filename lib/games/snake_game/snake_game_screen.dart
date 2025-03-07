import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int rows = 20;
  static const int columns = 20;
  static const int speed = 200; // Speed in milliseconds

  List<Offset> snake = [const Offset(10, 10)];
  Offset food = const Offset(5, 5);
  Direction direction = Direction.right;
  bool isGameOver = false;
  Timer? gameLoop;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    isGameOver = false;
    snake = [const Offset(10, 10)];
    food = generateFood();
    direction = Direction.right;
    score = 0;
    
    gameLoop?.cancel();
    gameLoop = Timer.periodic(const Duration(milliseconds: speed), (timer) {
      if (!isGameOver) {
        updateGame();
      } else {
        timer.cancel();
      }
    });
  }

  void updateGame() {
    setState(() {
      // Move the snake
      Offset newHead = getNextPosition(snake.first);
      snake.insert(0, newHead);

      // Check if snake eats food
      if (newHead == food) {
        food = generateFood();
        score += 10; // Increase score
      } else {
        snake.removeLast();
      }

      // Check collisions
      if (checkCollision(newHead)) {
        isGameOver = true;
        gameLoop?.cancel();
        showGameOverDialog();
      }
    });
  }

  Offset getNextPosition(Offset current) {
    switch (direction) {
      case Direction.up:
        return Offset(current.dx, current.dy - 1);
      case Direction.down:
        return Offset(current.dx, current.dy + 1);
      case Direction.left:
        return Offset(current.dx - 1, current.dy);
      case Direction.right:
        return Offset(current.dx + 1, current.dy);
    }
  }

  bool checkCollision(Offset position) {
    return position.dx < 0 ||
        position.dy < 0 ||
        position.dx >= columns ||
        position.dy >= rows ||
        snake.skip(1).contains(position);
  }

  Offset generateFood() {
    Random random = Random();
    Offset newFood;
    do {
      newFood = Offset(random.nextInt(columns).toDouble(), random.nextInt(rows).toDouble());
    } while (snake.contains(newFood));
    return newFood;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $score\nTry again?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              startGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void changeDirection(Direction newDirection) {
    if ((direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left) ||
        (direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up)) {
      return; // Prevent reversing direction
    }
    setState(() {
      direction = newDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < 0) {
          changeDirection(Direction.up);
        } else if (details.primaryDelta! > 0) {
          changeDirection(Direction.down);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! < 0) {
          changeDirection(Direction.left);
        } else if (details.primaryDelta! > 0) {
          changeDirection(Direction.right);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Snake Game')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Score: $score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                  ),
                  itemBuilder: (context, index) {
                    int x = index % columns;
                    int y = index ~/ columns;
                    Offset position = Offset(x.toDouble(), y.toDouble());

                    Color color = Colors.white;
                    if (snake.contains(position)) {
                      color = Colors.green;
                    } else if (position == food) {
                      color = Colors.red;
                    }

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                  itemCount: rows * columns,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }
}
