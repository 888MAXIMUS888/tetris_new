import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/briks.dart';
import 'package:new_tetris/material.dart';
import 'package:new_tetris/settings/settings.dart';
import 'games/tetris/player_panel.dart';
import 'status_panel/status_panel.dart';

class Display extends StatefulWidget {
  final ScreenBloc screenBloc;
  final double width;
  final gameState;

  Display({@required this.width, this.screenBloc, this.gameState});

  @override
  State<StatefulWidget> createState() {
    return DisplayState();
  }
}

class DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = widget.width * 0.6;
    return Stack(children: <Widget>[
      Container(
          width: widget.width,
          height: (playerPanelWidth - 6) * 2 + 6,
          child: GameMaterial(
            child: BrikSize(
              size: getBrikSizeForScreenWidth(playerPanelWidth),
              child: Row(
                children: <Widget>[
                  PlayerPanel(
                    width: playerPanelWidth,
                    screenBloc: widget.screenBloc,
                    gameState: widget.gameState,
                  ),
                  SizedBox(
                    width: widget.width - playerPanelWidth,
                    child: StatusPanel(
                      screenBloc: widget.screenBloc,
                    ),
                  )
                ],
              ),
            ),
          )),
      StreamBuilder(
        stream: widget.screenBloc.outSettingsScreen,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Container(
              width: widget.width,
              height: (playerPanelWidth - 6) * 2 + 6,
              child: Settings(),
            );
          } else {
            return Container(
              width: widget.width,
              height: (playerPanelWidth - 6) * 2 + 6,
            );
          }
        },
      )
    ]);
  }
}
