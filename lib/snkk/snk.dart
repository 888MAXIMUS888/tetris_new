import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/game_controller.dart';
import 'package:new_tetris/games/tetris.dart';
import 'package:new_tetris/material.dart';
import 'package:new_tetris/snkk/player_panel.dart';

const Color SCREEN_BACKGROUND = Color(0xff9ead86);
final screenBorderWidth = 3.0;

class SNK extends StatefulWidget {
  final ScreenBloc screenBloc;

  SNK({@required this.screenBloc});

  @override
  State<StatefulWidget> createState() {
    return SNKState();
  }
}

class SNKState extends State<SNK> {
  
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
                                child: 
                                Row(children: <Widget>[
                                  PlayerPanel(
                                      playerPanelWidth: playerPanelWidth, screenBloc: widget.screenBloc,),
                                  SizedBox(
                                    width: screenW - playerPanelWidth,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("points",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          // screenBloc.typeGameSelected == TypeGame.tetris
                                          //     ? Number(number: TetrisGameState.of(context).points)
                                          //     : Number(number: SnakeGameState.of(context).points),
                                          SizedBox(height: 10),
                                          // screenBloc.typeGameSelected == TypeGame.tetris
                                          //     ?
                                          Column(
                                            children: <Widget>[
                                              Text("cleans",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 4),
                                              // Number(number: TetrisGameState.of(context).cleared),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                          // : Container(),
                                          Text("level",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          // screenBloc.typeGameSelected == TypeGame.tetris
                                          //     ? Number(number: TetrisGameState.of(context).level)
                                          //     : Number(number: SnakeGameState.of(context).level),
                                          SizedBox(height: 10),
                                          // screenBloc.typeGameSelected == TypeGame.tetris
                                          // ?
                                          Column(
                                            children: <Widget>[
                                              Text("next",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 4),
                                              // _NextBlock()
                                            ],
                                          ),
                                          // : Container(),
                                          Spacer(),
                                          // _GameStatus(
                                          //   screenBloc: screenBloc,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  )
                                ])))),
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
