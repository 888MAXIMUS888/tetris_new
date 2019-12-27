import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/display.dart';

const Color SCREEN_BACKGROUND = Color(0xff9ead86);

class ScreenDecoration extends StatelessWidget {
  // final Widget child;

  final ScreenBloc screenBloc;
  final screenBorderWidth = 3.0;
  final gameState;

  const ScreenDecoration({Key key, @required this.screenBloc, this.gameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width * 0.8;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: screenBorderWidth),
          left: BorderSide(
              color: Theme.of(context).backgroundColor,
              width: screenBorderWidth),
          right: BorderSide(
              color: Theme.of(context).accentColor, width: screenBorderWidth),
          bottom: BorderSide(
              color: Theme.of(context).accentColor, width: screenBorderWidth),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        child: Container(
          padding: const EdgeInsets.all(3),
          color: SCREEN_BACKGROUND,
          child: Display(width: screenW, screenBloc: screenBloc, gameState: gameState,),
        ),
      ),
    );
  }
}