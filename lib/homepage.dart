import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'button.dart';
import 'player.dart';
import 'missile.dart';
import 'ball.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  static double playerX = 0;

  double missileX = playerX;
  double missileHeight = 10;
  bool midshot = false;

  double ballX = 0.5;
  double ballY = 0;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToPosition(height);
      });


      if(ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }

      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Center(
          child: Text(
            "You dead",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      );
    });
  }

  void moveLeft() {
    setState(() {
      if(playerX - 0.1 < -1) {
        // do nothing
      } else {
        playerX -= 0.1;  
      }

      if (!midshot) {
        missileX = playerX;
      }
    });
  }
  void moveRight() {
    setState(() {
      if(playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;  
      }
      missileX = playerX;
    });
  }
  void fireMissile() {
    if (midshot == false) {
      Timer.periodic( const Duration(milliseconds: 20), (timer) {

        midshot = true;

        setState(() {
          missileHeight += 10;
        });

        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        if (ballY > heightToPosition(missileHeight) && (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 0;
    midshot = false;
  }

  bool playerDies() {
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener (
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            moveRight();
        }

        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[200],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(
                      ballX: ballX, 
                      ballY: ballY
                    ),
                    MyMissile(
                      height: missileHeight,
                      missileX: missileX,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              )
            )
          ),
          Expanded(
            child: Container(
              color: Colors.grey[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}
