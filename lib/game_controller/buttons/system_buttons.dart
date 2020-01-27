import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';
import '../../games/tetris/tetris.dart';

class SystemButtonGroup extends StatelessWidget {
  final Size systemButtonSize = const Size(24, 24);
  final ScreenBloc screenBloc;

  SystemButtonGroup({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Description(
          text: "sounds",
          child: Button(
              size: systemButtonSize,
              color: Theme.of(context).indicatorColor,
              enableLongPress: false,
              onTap: () {
                screenBloc.typeGameSelected == TypeGame.tetris
                    ? TetrisGame.of(context).soundSwitch()
                    : screenBloc.soundSwitch();
              },
              onLongPress: null,
              onLongPressEnd: null),
        ),
        Description(
          text: "pause/resume",
          child: Button(
              size: systemButtonSize,
              color: Theme.of(context).indicatorColor,
              enableLongPress: false,
              onTap: () {
                screenBloc.typeGameSelected == TypeGame.tetris
                    ? TetrisGame.of(context).pauseOrResume()
                    : screenBloc.pauseOrResumeButton();
              },
              onLongPress: null,
              onLongPressEnd: null),
        ),
        Description(
          text: "reset",
          child: Button(
              size: systemButtonSize,
              enableLongPress: false,
              color: Theme.of(context).focusColor,
              onTap: () {
                screenBloc.typeGameSelected == TypeGame.tetris
                    ? TetrisGame.of(context).reset()
                    : screenBloc.resetButton();
              },
              onLongPress: null,
              onLongPressEnd: null),
        )
      ],
    );
  }
}
