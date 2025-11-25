import 'dart:math';

import 'package:flutterconf/pong/components/ball.dart';
import 'package:flutterconf/pong/components/paddle.dart';

class GameEngine {
  GameEngine({required this.screenWidth, required this.screenHeight}) {
    _initializeGame();
  }

  final double screenWidth;
  final double screenHeight;

  // Game properties
  late Ball ball;
  late Paddle playerPaddle;
  late Paddle opponentPaddle;

  int playerScore = 0;
  int opponentScore = 0;

  final double _ballSpeed = 5;
  final double _paddleWidth = 20;
  final double _paddleHeight = 100;
  final double _ballSize = 20;

  void _initializeGame() {
    ball = Ball(
      x: screenWidth / 2,
      y: screenHeight / 2,
      size: _ballSize,
      xVel: _ballSpeed,
      yVel: _ballSpeed,
    );

    playerPaddle = Paddle(
      x: 0,
      y: screenHeight / 2 - _paddleHeight / 2,
      width: _paddleWidth,
      height: _paddleHeight,
    );

    opponentPaddle = Paddle(
      x: screenWidth - _paddleWidth,
      y: screenHeight / 2 - _paddleHeight / 2,
      width: _paddleWidth,
      height: _paddleHeight,
    );

    playerScore = 0;
    opponentScore = 0;
  }

  void update() {
    // Update ball position
    ball.x += ball.xVel;
    ball.y += ball.yVel;

    // Ball collision with top/bottom walls
    if (ball.y <= 0 || ball.y >= screenHeight - ball.size) {
      ball.yVel *= -1;
    }

    // Ball collision with paddles
    _checkPaddleCollision(playerPaddle, true);
    _checkPaddleCollision(opponentPaddle, false);

    // Score
    if (ball.x <= 0) {
      opponentScore++;
      _resetBall();
    } else if (ball.x >= screenWidth - ball.size) {
      playerScore++;
      _resetBall();
    }

    // Opponent AI
    opponentPaddle.y = ball.y - opponentPaddle.height / 2;
    if (opponentPaddle.y < 0) opponentPaddle.y = 0;
    if (opponentPaddle.y > screenHeight - opponentPaddle.height) {
      opponentPaddle.y = screenHeight - opponentPaddle.height;
    }
  }

  void _checkPaddleCollision(Paddle paddle, bool isPlayer) {
    if (ball.x < paddle.x + paddle.width &&
        ball.x + ball.size > paddle.x &&
        ball.y < paddle.y + paddle.height &&
        ball.y + ball.size > paddle.y) {
      ball.xVel *= -1;
      // Add a slight random angle variation
      final random = Random();
      ball.yVel += (random.nextDouble() - 0.5) * 2;
    }
  }

  void _resetBall() {
    ball.x = screenWidth / 2;
    ball.y = screenHeight / 2;
    ball.xVel = _ballSpeed * (Random().nextBool() ? 1 : -1);
    ball.yVel = _ballSpeed * (Random().nextBool() ? 1 : -1);
  }

  void movePlayerPaddle(double newY) {
    playerPaddle.y = newY - playerPaddle.height / 2;
    if (playerPaddle.y < 0) playerPaddle.y = 0;
    if (playerPaddle.y > screenHeight - playerPaddle.height) {
      playerPaddle.y = screenHeight - playerPaddle.height;
    }
  }
}
