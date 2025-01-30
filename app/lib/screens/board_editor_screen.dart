import 'package:flutter/material.dart';
import 'package:editable_chess_board/editable_chess_board.dart';
import 'package:chess/chess.dart' as chess;

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.title, required this.startFEN});

  final String title;
  final String startFEN;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final _controller;

  @override
  void initState() {
    super.initState();
    _controller = PositionController(widget.startFEN);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: deviceSize.height * (isLandscape ? 0.6 : 0.6),
              child: EditableChessBoard(
                boardSize: isLandscape
                    ? deviceSize.height * 0.45
                    : deviceSize.width * 0.9,
                controller: _controller,
                labels: Labels(
                  playerTurnLabel: 'Player turn :',
                  whitePlayerLabel: 'White',
                  blackPlayerLabel: 'Black',
                  availableCastlesLabel: 'Available castles :',
                  whiteOOLabel: 'White O-O',
                  whiteOOOLabel: 'White O-O-O',
                  blackOOLabel: 'Black O-O',
                  blackOOOLabel: 'Black O-O-O',
                  enPassantLabel: 'En passant square :',
                  drawHalfMovesCountLabel: 'Draw half moves count : ',
                  moveNumberLabel: 'Move number : ',
                  submitFieldLabel: 'Validate',
                  currentPositionLabel: 'Current position: ',
                  copyFenLabel: 'Copy position',
                  pasteFenLabel: 'Paste position',
                  resetPosition: 'Reset position',
                  standardPosition: 'Standard position',
                  erasePosition: 'Erase position',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final isEmptyBoard =
                        _controller.position.split(' ')[0] == "8/8/8/8/8/8/8/8";
                    final isValidPosition = !isEmptyBoard &&
                        chess.Chess.validate_fen(
                            _controller.position)['valid'] ==
                            true;
                    final message = isValidPosition
                        ? "Valid position"
                        : "Illegal position !";
                    final snackBar = SnackBar(
                      content: Text(message),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Validate position'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension on PositionController {
  get position => null;
}