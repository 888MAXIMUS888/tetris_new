import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/briks.dart';
import 'package:new_tetris/games/snake.dart';
import 'package:new_tetris/games/tetris.dart';

enum TypeGame { tetris, snake }

const _PLAYER_PANEL_PADDING = 6;

const GAME_PAD_MATRIX_W = 10;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - _PLAYER_PANEL_PADDING) / GAME_PAD_MATRIX_W);
}

class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;
  final ScreenBloc screenBloc;
  final gameState;

  PlayerPanel(
      {Key key, @required double width, this.screenBloc, this.gameState})
      : assert(width != null && width != 0),
        size = Size(width, width * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("size : $size");
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: <Widget>[
            _PlayerPad(screenBloc: screenBloc),
            _GameUninitialized(screenBloc: screenBloc),
          ],
        ),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  final ScreenBloc screenBloc;
  _PlayerPad({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: screenBloc.outTypeGame,
      builder: (context, snapshot) {
        if (snapshot.data == "tetris") {
          return Column(
            children: TetrisGameState.of(context).data.map((list) {
              return Row(
                children: list.map((b) {
                  return b == 1
                      ? const Brik.normal()
                      : b == 2 ? const Brik.highlight() : const Brik.empty();
                }).toList(),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: SnakeGameState.of(context).data.map((list) {
              return Row(
                children: list.map((b) {
                  return b == 1
                      ? const Brik.normal()
                      : b == 2 ? const Brik.highlight() : const Brik.empty();
                }).toList(),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  final ScreenBloc screenBloc;

  _GameUninitialized({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    if(screenBloc.states == GameStates.selectedTetris || screenBloc.states == GameStates.selectedSnake){
      return StreamBuilder(
      stream: screenBloc.outTypeGame,
      builder: (context, snapshot) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16),
              Text(
                snapshot.data.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
    } else {
      return Container();
    }
    
  }
}
