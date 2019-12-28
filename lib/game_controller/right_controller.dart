import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'dart:math' as math;

import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';
import 'package:new_tetris/game_snake.dart';
import 'package:new_tetris/gamer.dart';

bool openSettingsScreen = false;

class RightController extends StatelessWidget {
  final Size directionButtonSize;
  final double _iconSize = 16;
  final Size systemButtonSize = const Size(24, 24);
  final double directionSpace = 16;
  final ScreenBloc screenBloc;

  RightController({@required this.directionButtonSize, this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox.fromSize(size: directionButtonSize * 6.8),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 25),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Icon(
                          Icons.arrow_right,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Icon(
                          Icons.arrow_left,
                          size: _iconSize,
                        )),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: _iconSize,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: directionSpace),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Button(
                      color: Theme.of(context).buttonColor,
                      enableLongPress: false,
                      size: directionButtonSize,
                      onTap: () {
                        screenBloc.typeGameSelected == TypeGame.tetris
                            ? TetrisGame.of(context).rotate()
                            : SnakeGame.of(context).up();
                      }),
                  SizedBox(width: directionSpace),
                  Button(
                      color: Theme.of(context).buttonColor,
                      size: directionButtonSize,
                      onTap: () {
                        if (screenBloc.typeGameSelected == TypeGame.tetris &&
                            screenBloc.states == GameStates.selectedTetris) {
                          screenBloc.typeGame.add("snake");
                          screenBloc.typeGameSelected = TypeGame.snake;
                          screenBloc.states = GameStates.selectedSnake;
                          print("_typeGame ${screenBloc.typeGameSelected}");
                        } else if (screenBloc.typeGameSelected ==
                                TypeGame.snake &&
                            screenBloc.states == GameStates.selectedSnake) {
                          screenBloc.typeGame.add("tetris");
                          screenBloc.typeGameSelected = TypeGame.tetris;
                          screenBloc.states = GameStates.selectedTetris;
                          print("_typeGame ${screenBloc.typeGameSelected}");
                        } else if (screenBloc.typeGameSelected ==
                            TypeGame.tetris) {
                          TetrisGame.of(context).right();
                        } else if (screenBloc.typeGameSelected ==
                            TypeGame.snake) {
                          SnakeGame.of(context).right();
                        }
                      })
                ],
              ),
              SizedBox(height: directionSpace),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Button(
                      color: Theme.of(context).buttonColor,
                      size: directionButtonSize,
                      onTap: () {
                        if (screenBloc.typeGameSelected == TypeGame.tetris &&
                            screenBloc.states == GameStates.selectedTetris) {
                          screenBloc.typeGame.add("snake");
                          screenBloc.typeGameSelected = TypeGame.snake;
                          screenBloc.states = GameStates.selectedSnake;
                          print("_typeGame ${screenBloc.typeGameSelected}");
                        } else if (screenBloc.typeGameSelected ==
                                TypeGame.snake &&
                            screenBloc.states == GameStates.selectedSnake) {
                          screenBloc.typeGame.add("tetris");
                          screenBloc.typeGameSelected = TypeGame.tetris;
                          screenBloc.states = GameStates.selectedTetris;
                          print("_typeGame ${screenBloc.typeGameSelected}");
                        } else if (screenBloc.typeGameSelected ==
                            TypeGame.tetris) {
                          TetrisGame.of(context).left();
                        } else if (screenBloc.typeGameSelected ==
                            TypeGame.snake) {
                          SnakeGame.of(context).left();
                        }
                      }),
                  SizedBox(width: directionSpace),
                  Button(
                    color: Theme.of(context).buttonColor,
                    size: directionButtonSize,
                    onTap: () {
                      screenBloc.typeGameSelected == TypeGame.tetris
                          ? TetrisGame.of(context).down()
                          : SnakeGame.of(context).down();
                    },
                  ),
                ],
              ),
              SizedBox(height: directionSpace),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: Description(
            text: "settings",
            child: Button(
                size: systemButtonSize,
                enableLongPress: false,
                color: Theme.of(context).indicatorColor,
                onTap: () {
                  openSettingsScreen = !openSettingsScreen;
                  TetrisGame.of(context).settings(screenBloc);
                }),
          ),
        )
      ],
    );
  }
}
