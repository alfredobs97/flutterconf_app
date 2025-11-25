import 'package:flutter/material.dart';
import 'package:flutterconf/pong/widgets/game_canvas.dart';

class PongPage extends StatelessWidget {
  const PongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pong Game'),
      ),
      body: const GameCanvas(),
    );
  }
}
