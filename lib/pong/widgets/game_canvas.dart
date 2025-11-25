import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterconf/pong/engine/game_engine.dart';

class GameCanvas extends StatefulWidget {
  const GameCanvas({super.key});

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas>
    with SingleTickerProviderStateMixin {
  late GameEngine gameEngine;
  late AnimationController _controller;
  ui.Image? dashImage;

  @override
  void initState() {
    super.initState();
    gameEngine = GameEngine(screenWidth: 0, screenHeight: 0);
    _loadImage('assets/pong/dash-search.png');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000 ~/ 60), // 60 FPS
    )..repeat();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          gameEngine.update();
        });
      }
    });
  }

  Future<void> _loadImage(String path) async {
    final byteData = await rootBundle.load(path);
    final image = await decodeImageFromList(byteData.buffer.asUint8List());
    if (mounted) {
      setState(() {
        dashImage = image;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (gameEngine.screenWidth != constraints.maxWidth ||
            gameEngine.screenHeight != constraints.maxHeight) {
          gameEngine = GameEngine(
            screenWidth: constraints.maxWidth,
            screenHeight: constraints.maxHeight,
          );
        }
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            gameEngine.movePlayerPaddle(details.localPosition.dy);
          },
          child: CustomPaint(
            painter: _GamePainter(
              gameEngine,
              dashImage,
              Theme.of(context),
            ),
            child: Container(),
          ),
        );
      },
    );
  }
}

class _GamePainter extends CustomPainter {
  _GamePainter(this.gameEngine, this.dashImage, this.theme);

  final GameEngine gameEngine;
  final ui.Image? dashImage;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      // Draw background
      ..drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = theme.scaffoldBackgroundColor,
      )
      // Draw player paddle
      ..drawRect(
        Rect.fromLTWH(
          gameEngine.playerPaddle.x,
          gameEngine.playerPaddle.y,
          gameEngine.playerPaddle.width,
          gameEngine.playerPaddle.height,
        ),
        Paint()..color = theme.primaryColor,
      )
      // Draw opponent paddle
      ..drawRect(
        Rect.fromLTWH(
          gameEngine.opponentPaddle.x,
          gameEngine.opponentPaddle.y,
          gameEngine.opponentPaddle.width,
          gameEngine.opponentPaddle.height,
        ),
        Paint()..color = theme.primaryColor.withAlpha(128),
      );

    // Draw ball
    if (dashImage != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        dashImage!.width.toDouble(),
        dashImage!.height.toDouble(),
      );
      final dst = Rect.fromLTWH(
        gameEngine.ball.x - gameEngine.ball.size / 2,
        gameEngine.ball.y - gameEngine.ball.size / 2,
        gameEngine.ball.size,
        gameEngine.ball.size,
      );
      canvas.drawImageRect(dashImage!, src, dst, Paint());
    }

    // Draw scores
    final textStyle = TextStyle(
      color: theme.primaryColor,
      fontSize: 30,
    );
    final playerTextSpan = TextSpan(
      text: '${gameEngine.playerScore}',
      style: textStyle,
    );
    final playerTextPainter =
        TextPainter(
            text: playerTextSpan,
            textDirection: TextDirection.ltr,
          )
          ..layout()
          ..paint(canvas, Offset(size.width / 4, 50));

    final opponentTextSpan = TextSpan(
      text: '${gameEngine.opponentScore}',
      style: textStyle,
    );
    final opponentTextPainter = TextPainter(
      text: opponentTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    opponentTextPainter.paint(
      canvas,
      Offset(size.width * 3 / 4 - opponentTextPainter.width, 50),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
