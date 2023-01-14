import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button.dart';
import 'player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double playerX = 0;

  double missileX = 0;
  double missileY = 1;

  void moveLeft() {
    setState(() {
      if(playerX - 0.1 < -1) {
        
      } else {
        playerX -= 0.1;  
      }
    });
  }
  void moveRight() {
    setState(() {
      if(playerX + 0.1 > 1) {
        
      } else {
        playerX += 0.1;  
      }
    });
  }
  void fireMissile() {
    Timer.periodic(Duration(milliseconds: 100), (timer)) {
      
    })
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
                    MyPlayer(
                      playerX: playerX,
                    )
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
