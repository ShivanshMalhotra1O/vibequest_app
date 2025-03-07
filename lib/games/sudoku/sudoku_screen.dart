import 'package:flutter/material.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  SudokuScreenState createState() => SudokuScreenState();
}

class SudokuScreenState extends State<SudokuScreen> {
  List<List<int?>> board = [
    [1, null, null, 4],
    [null, 3, 1, null],
    [null, 1, 3, null],
    [4, null, null, 2],
  ];

  List<List<int>> solution = [
    [1, 2, 3, 4],
    [4, 3, 1, 2],
    [2, 1, 4, 3],
    [3, 4, 2, 1],
  ];

  List<List<bool>> isEditable = [
    [false, true, true, false],
    [true, false, false, true],
    [true, false, false, true],
    [false, true, true, false],
  ];

  void updateCell(int row, int col, int value) {
    if (isEditable[row][col]) {
      setState(() {
        board[row][col] = value;
      });
      checkSolution();
    }
  }

  bool isSolved() {
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (board[r][c] != solution[r][c]) return false;
      }
    }
    return true;
  }

  void checkSolution() {
    if (isSolved()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You solved the Sudoku puzzle!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("4x4 Sudoku")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              int row = index ~/ 4;
              int col = index % 4;
              return GestureDetector(
                onTap: isEditable[row][col]
                    ? () async {
                        int? selectedNumber = await showDialog<int>(
                          context: context,
                          builder: (context) => NumberPickerDialog(),
                        );
                        if (selectedNumber != null) {
                          updateCell(row, col, selectedNumber);
                        }
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: isEditable[row][col]
                        ? Colors.blue[200]
                        : Colors.grey[300], // Different color for fixed numbers
                  ),
                  child: Center(
                    child: Text(
                      board[row][col]?.toString() ?? '',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NumberPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick a number"),
      content: Wrap(
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, index + 1),
              child: Text("${index + 1}"),
            ),
          );
        }),
      ),
    );
  }
}
