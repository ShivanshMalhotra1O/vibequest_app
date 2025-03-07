import 'package:flutter/material.dart';
import 'dart:async';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  MemoryGameState createState() => MemoryGameState();
}

class MemoryGameState extends State<MemoryGame> {
  List<String> cards = [
    'A', 'A', 'B', 'B', 'C', 'C', 'D', 'D',
    'E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'
  ];
  List<bool> revealed = List.filled(16, false);
  int? firstIndex;
  int? secondIndex;
  bool isProcessing = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    cards.shuffle();
  }

  void _handleTap(int index) {
    if (isProcessing || revealed[index]) return;

    setState(() {
      revealed[index] = true;
    });

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      secondIndex = index;
      isProcessing = true;

      if (cards[firstIndex!] == cards[secondIndex!]) {
        setState(() {
          score += 10;
        });
        firstIndex = null;
        secondIndex = null;
        isProcessing = false;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            revealed[firstIndex!] = false;
            revealed[secondIndex!] = false;
            firstIndex = null;
            secondIndex = null;
            isProcessing = false;
          });
        });
      }
    }
  }

  void _resetGame() {
    setState(() {
      cards.shuffle();
      revealed = List.filled(16, false);
      firstIndex = null;
      secondIndex = null;
      isProcessing = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: revealed[index] ? Colors.blue[100] : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          revealed[index] ? cards[index] : '',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text("Restart Game"),
            ),
          ],
        ),
      ),
    );
  }
}
