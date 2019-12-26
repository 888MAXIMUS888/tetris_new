import 'package:flutter/material.dart';
import 'package:new_tetris/game_controller/left_controller.dart';
import 'package:new_tetris/game_controller/right_controller.dart';

class GameController extends StatelessWidget {
  final Size directionButtonSize = const Size(48, 48);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Row(
        children: <Widget>[
          Expanded(child: LeftController()),
          Expanded(
              child: RightController(directionButtonSize: directionButtonSize))
        ],
      ),
    );
  }
}
