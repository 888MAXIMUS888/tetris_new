import 'package:flutter/material.dart';
import 'package:new_tetris/audios.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/game_controller.dart';
import 'package:new_tetris/game_controller/keyboard_controller.dart';
import 'package:new_tetris/game_snake.dart';
import 'package:new_tetris/gamer.dart';
import 'package:new_tetris/screen_decoration.dart';

class Tetris extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TetrisState();
  }
}

class TetrisState extends State<Tetris> {
  ScreenBloc screenBloc = ScreenBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
            child: StreamBuilder(
      stream: screenBloc.outTypeGame,
      builder: (context, snapshot) {
        if (snapshot.data == "tetris") {
          return Sound(
              child: TetrisGame(
                  screenBloc: screenBloc,
                  child: KeyboardController(
                      screenBloc: screenBloc,
                      child: Container(
                          padding: MediaQuery.of(context).padding,
                          child: Column(children: <Widget>[
                            Spacer(),
                            ScreenDecoration(
                              screenBloc: screenBloc,
                              gameState: TetrisGameState.of(context),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            GameController(screenBloc: screenBloc)
                          ])))));
        } else {
          print("snake");
          return Sound(
              child: SnakeGame(
                  screenBloc: screenBloc,
                  child: KeyboardController(
                      screenBloc: screenBloc,
                      child: Container(
                          padding: MediaQuery.of(context).padding,
                          child: Column(children: <Widget>[
                            Spacer(),
                            ScreenDecoration(
                              screenBloc: screenBloc,
                              gameState: SnakeGameState.of(context),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            GameController(screenBloc: screenBloc)
                          ])))));
        }
      },
    )));
  }
}
