import 'package:flutter/material.dart';

class PongPage extends StatelessWidget {
  const PongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pong Game'),
      ),
      body: const Center(
        child: Text('Welcome to Pong!'),
      ),
    );
  }
}
