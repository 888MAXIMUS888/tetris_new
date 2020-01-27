import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/game_controller.dart';
import 'package:new_tetris/games/snake/player_panel.dart';
import 'package:new_tetris/material.dart';
import 'package:new_tetris/settings/settings.dart';

import '../../status_panel/status_panel.dart';

const Color SCREEN_BACKGROUND = Color(0xff9ead86);
final screenBorderWidth = 3.0;

class Snake extends StatefulWidget {
  final ScreenBloc screenBloc;

  Snake({@required this.screenBloc});

  @override
  State<StatefulWidget> createState() {
    return SnakeState();
  }

  static SnakeState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SnakeState) as SnakeState);
  }
}

class SnakeState extends State<Snake> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width * 0.8;
    final playerPanelWidth = screenW * 0.6;
    return Container(
      padding: MediaQuery.of(context).padding,
      child: Column(
        children: <Widget>[
          SizedBox(height: 52),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).backgroundColor,
                    width: screenBorderWidth),
                left: BorderSide(
                    color: Theme.of(context).backgroundColor,
                    width: screenBorderWidth),
                right: BorderSide(
                    color: Theme.of(context).accentColor,
                    width: screenBorderWidth),
                bottom: BorderSide(
                    color: Theme.of(context).accentColor,
                    width: screenBorderWidth),
              ),
            ),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black54)),
              child: Container(
                padding: const EdgeInsets.all(3),
                color: SCREEN_BACKGROUND,
                child: Stack(
                  children: <Widget>[
                    Container(
                        width: screenW,
                        height: (playerPanelWidth - 6) * 2 + 6,
                        child: GameMaterial(
                            child: BrikSize2(
                                size:
                                    getBrikSizeForScreenWidth(playerPanelWidth),
                                child: Row(children: <Widget>[
                                  PlayerPanel(
                                    playerPanelWidth: playerPanelWidth,
                                    screenBloc: widget.screenBloc,
                                  ),
                                  SizedBox(
                                    width: screenW - playerPanelWidth,
                                    child: StatusPanel(
                                      screenBloc: widget.screenBloc,
                                    ),
                                  )
                                ])))),
                    StreamBuilder(
                      stream: widget.screenBloc.outSettingsScreen,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Container(
                            width: screenW,
                            height: (playerPanelWidth - 6) * 2 + 6,
                            child: Settings(),
                          );
                        } else {
                          return Container(
                            width: screenW,
                            height: (playerPanelWidth - 6) * 2 + 6,
                          );
                        }
                      },
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          GameController(screenBloc: widget.screenBloc)
        ],
      ),
    );
  }
}
