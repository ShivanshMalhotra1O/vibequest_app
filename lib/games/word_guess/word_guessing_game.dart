import 'dart:math';
import 'package:flutter/material.dart';

class WordGuessingGame extends StatefulWidget {
  const WordGuessingGame({super.key});

  @override
  WordGuessingGameState createState() => WordGuessingGameState();
}

class WordGuessingGameState extends State<WordGuessingGame> {
  final List<String> words = [
    "FLUTTER", "DART", "WIDGET", "STATE", "MOBILE", "DEVELOPER", "APPLICATION", "ANDROID"
  ];
  late String wordToGuess;
  List<String> guessedLetters = [];
  int attemptsLeft = 6;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Word Guessing Game")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the word with hidden letters
              Text(
                _getDisplayedWord(),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 6),
              ),
              const SizedBox(height: 30),

              // Show attempts left
              Text(
                "Attempts Left: $attemptsLeft",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 30),

              // Jumbled Alphabet Keyboard
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                children: _getJumbledAlphabets().map((letter) {
                  return ElevatedButton(
                    onPressed: guessedLetters.contains(letter) || attemptsLeft == 0
                        ? null
                        : () => _guessLetter(letter),
                    child: Text(letter, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // Win or lose message
              if (_isGameWon())
                const Text(
                  "🎉 Congratulations! You Won! 🎉",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                )
              else if (attemptsLeft == 0)
                Text(
                  "Game Over! The word was: $wordToGuess",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),

              const SizedBox(height: 30),

              // Restart button
              ElevatedButton(
                onPressed: _resetGame,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Restart Game", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guessLetter(String letter) {
    setState(() {
      guessedLetters.add(letter);
      if (!wordToGuess.contains(letter)) {
        attemptsLeft--;
      }
    });
  }

  String _getDisplayedWord() {
    return wordToGuess.split("").map((letter) {
      return guessedLetters.contains(letter) ? letter : "_";
    }).join(" ");
  }

  bool _isGameWon() {
    return wordToGuess.split("").every((letter) => guessedLetters.contains(letter));
  }

  void _resetGame() {
    setState(() {
      wordToGuess = words[Random().nextInt(words.length)];
      guessedLetters.clear();
      attemptsLeft = 6;
    });
  }

  // Function to generate a shuffled alphabet list
  List<String> _getJumbledAlphabets() {
    List<String> alphabets = List.generate(26, (index) => String.fromCharCode(65 + index)); // A-Z
    alphabets.shuffle(Random()); // Shuffle letters randomly
    return alphabets;
  }
}
