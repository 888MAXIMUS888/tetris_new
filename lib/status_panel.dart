import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/briks.dart';
import 'package:new_tetris/games/snake/snake_game.dart';
// import 'package:new_tetris/games/snake.dart';
import 'package:new_tetris/games/tetris.dart';
import 'package:new_tetris/images.dart';
import 'package:new_tetris/resourses/bloc.dart';

class StatusPanel extends StatelessWidget {
  final ScreenBloc screenBloc;

  StatusPanel({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("points", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          screenBloc.typeGameSelected == TypeGame.tetris
              ? Number(number: TetrisGameState.of(context).points)
              : StreamBuilder(
                  stream: screenBloc.outGamePoints,
                  builder: (context, snapshot) {
                    return Number(number: snapshot.data);
                  },
                ),
          SizedBox(height: 10),
          screenBloc.typeGameSelected == TypeGame.tetris
              ? Column(
                  children: <Widget>[
                    Text("cleans",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Number(number: TetrisGameState.of(context).cleared),
                    SizedBox(height: 10),
                  ],
                )
              : Container(),
          Text("level", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          screenBloc.typeGameSelected == TypeGame.tetris
              ? Number(number: TetrisGameState.of(context).level)
              : StreamBuilder(
                  stream: screenBloc.outGameLevel,
                  builder: (context, snapshot) {
                    return Number(number: screenBloc.level);
                  },
                ),
          SizedBox(height: 10),
          screenBloc.typeGameSelected == TypeGame.tetris
              ? Column(
                  children: <Widget>[
                    Text("next", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    _NextBlock()
                  ],
                )
              : Container(),
          SizedBox(height: 4),
          screenBloc.typeGameSelected == TypeGame.tetris
              ? Container()
              : Column(
                  children: <Widget>[
                    Text("length",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    StreamBuilder(
                      stream: screenBloc.outSnakeLength,
                      builder: (context, snapshot) {
                        return Number(number: snapshot.data);
                      },
                    ),
                  ],
                ),
          SizedBox(height: 10),
          Spacer(),
          GameStatus(
            screenBloc: screenBloc,
          ),
        ],
      ),
    );
  }
}

class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[TetrisGameState.of(context).next.type];
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1 ? const Brik.normal() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class GameStatus extends StatefulWidget {
  final ScreenBloc screenBloc;

  GameStatus({@required this.screenBloc});

  @override
  GameStatusState createState() {
    return new GameStatusState();
  }
}

class GameStatusState extends State<GameStatus> {
  Timer _timer;

  bool _colonEnable = true;

  int _minute;

  int _hour;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // widget.screenBloc.typeGameSelected == TypeGame.tetris
        //     ?
        // IconSound(enable: TetrisGameState.of(context).muted),
        // : IconSound(enable: SnakeGameState.of(context).muted),
        SizedBox(width: 4),
        widget.screenBloc.typeGameSelected == TypeGame.tetris
            ? IconPause(
                enable: TetrisGameState.of(context).states == GameStates.paused)
            : IconPause(enable: widget.screenBloc.states == GameStates.paused),
        Spacer(),
        Number(number: _hour, length: 2, padWithZero: true),
        IconColon(enable: _colonEnable),
        Number(number: _minute, length: 2, padWithZero: true),
      ],
    );
  }
}
