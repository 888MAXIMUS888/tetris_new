import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/left_controller.dart';
import 'package:new_tetris/game_controller/right_controller.dart';

class GameController extends StatelessWidget {

  final ScreenBloc screenBloc;
  final Size directionButtonSize = const Size(48, 48);

  GameController({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Row(
        children: <Widget>[
          Expanded(child: LeftController(screenBloc: screenBloc)),
          Expanded(
              child: RightController(directionButtonSize: directionButtonSize, screenBloc: screenBloc))
        ],
      ),
    );
  }
}
