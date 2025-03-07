import 'package:flutter/material.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  HangmanGameState createState() => HangmanGameState();
}

class HangmanGameState extends State<HangmanGame> {
  final String word = "FLUTTER"; // Word to guess
  List<String> guessedLetters = [];
  int attemptsLeft = 6; // Maximum incorrect guesses allowed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hangman")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display word with hidden letters
          Text(
            _getDisplayedWord(),
            style: const TextStyle(fontSize: 32, letterSpacing: 4),
          ),
          const SizedBox(height: 20),

          // Show attempts left
          Text(
            "Attempts Left: $attemptsLeft",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Alphabet buttons for guessing letters
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").map((letter) {
              return ElevatedButton(
                onPressed: guessedLetters.contains(letter) || attemptsLeft == 0
                    ? null
                    : () => _guessLetter(letter),
                child: Text(letter),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Game over or win message
          if (_isGameWon())
            const Text(
              "Congratulations! You Won 🎉",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            )
          else if (attemptsLeft == 0)
            Text(
              "Game Over! The word was: $word",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
            ),

          const SizedBox(height: 20),

          // Reset button
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text("Restart Game"),
          ),
        ],
      ),
    );
  }

  void _guessLetter(String letter) {
    setState(() {
      guessedLetters.add(letter);
      if (!word.contains(letter)) {
        attemptsLeft--;
      }
    });
  }

  String _getDisplayedWord() {
    return word.split("").map((letter) {
      return guessedLetters.contains(letter) ? letter : "_";
    }).join(" ");
  }

  bool _isGameWon() {
    return word.split("").every((letter) => guessedLetters.contains(letter));
  }

  void _resetGame() {
    setState(() {
      guessedLetters.clear();
      attemptsLeft = 6;
    });
  }
}
