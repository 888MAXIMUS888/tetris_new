import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';
import 'package:new_tetris/game_snake.dart';
import 'package:new_tetris/gamer.dart';
// import 'package:new_tetris/gamer.dart';

class DropButton extends StatelessWidget {
  final ScreenBloc screenBloc;

  DropButton({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return Description(
        text: 'drop',
        child: Button(
            color: Theme.of(context).buttonColor,
            enableLongPress: false,
            size: Size(90, 90),
            onTap: () {
              screenBloc.typeGameSelected == TypeGame.tetris
                  ? TetrisGame.of(context).drop()
                  : SnakeGame.of(context).drop();
            }));
  }
}
