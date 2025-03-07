import 'package:flutter/material.dart';
import 'package:vibequest/games/tic_tac_toe/tic_tac_toe_game.dart';
// import 'package:vibequest/games/hangman/hangman_game.dart';
import 'package:vibequest/games/word_guess/word_guessing_game.dart';
import 'package:vibequest/games/memory_game/memory_game.dart';
import 'package:vibequest/games/snake_game/snake_game_screen.dart';
import 'package:vibequest/games/pong_game/pong_game_screen.dart';
import 'package:vibequest/games/sudoku/sudoku_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 300) {
      if (!_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = true);
      }
    } else {
      if (_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = false);
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeQuest', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Welcome to VibeQuest!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: const [
                  GameCard(image: 'assets/tic_tac_toe.png', title: 'Tic Tac Toe', game: TicTacToeGame()),
                  GameCard(image: 'assets/word_guess.png', title: 'Guess the Word', game: WordGuessingGame()),
                  GameCard(image: 'assets/memory_game.png', title: 'Memory Game', game: MemoryGame()),
                  GameCard(image: 'assets/snake_game.png', title: 'Snake Game', game: SnakeGameScreen()),
                  GameCard(image: 'assets/pong.png', title: 'Pong', game: PongGameScreen()),
                  // GameCard(image: 'assets/hangman.png', title: 'Hangman', game: HangmanGame()),
                  GameCard(image: 'assets/sudoku.png', title: 'Sudoku', game: SudokuScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }
}

class GameCard extends StatelessWidget {
  final String image;
  final String title;
  final Widget game;

  const GameCard({
    required this.image,
    required this.title,
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(image, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => game)),
                    child: const Text('Play'),
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
