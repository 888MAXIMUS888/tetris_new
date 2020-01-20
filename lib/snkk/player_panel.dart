import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/main.dart';
import 'package:new_tetris/snkk/paint.dart';
import 'package:new_tetris/snkk/paint2.dart';
import 'package:new_tetris/snkk/paint3.dart';

const _COLOR_NORMAL = Colors.black87;

const _COLOR_NULL = Colors.black12;

const _COLOR_HIGHLIGHT = Color(0xFF560000);

const _PLAYER_PANEL_PADDING = 6;

const GAME_PAD_MATRIX_W = 10;

const GAME_PAD_MATRIX_H = 20;

class BrikSize2 extends InheritedWidget {
  const BrikSize2({
    Key key,
    @required this.size,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final Size size;

  static BrikSize2 of(BuildContext context) {
    final brikSize =
        context.inheritFromWidgetOfExactType(BrikSize2) as BrikSize2;
    assert(brikSize != null, "....");
    return brikSize;
  }

  @override
  bool updateShouldNotify(BrikSize2 old) {
    return old.size != size;
  }
}

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - _PLAYER_PANEL_PADDING) / GAME_PAD_MATRIX_W);
}

class PlayerPanel extends StatefulWidget with RouteAware {
  final ScreenBloc screenBloc;
  final playerPanelWidth;

  PlayerPanel({@required this.playerPanelWidth, this.screenBloc});
  @override
  State<StatefulWidget> createState() {
    return PlayerPanelState();
  }
}

class PlayerPanelState extends State<PlayerPanel> with RouteAware {
  List<Color> brickColors = [Colors.black12, Colors.black87];
  List<int> snake = [1, 1];
  Timer timer;
  List<int> snakePosition = [];

  @override
  void initState() {
    startingSnake();
    widget.screenBloc.snakeGameStates.listen((states) {
      if (states == GameState.START) {
        return getLatestSnake();
      } else if (states == GameState.FAILURE) {
        timer.cancel();
      } else {
        return Stack(
          children: <Widget>[
            Positioned(
                left: 400,
                top: 400,
                child: Center(
                    child: Container(
                  child: Text("Snake"),
                ))),
          ],
        );
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = BrikSize2.of(context).size.width;
    return SizedBox.fromSize(
        size: Size(widget.playerPanelWidth, widget.playerPanelWidth * 2),
        child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Stack(children: <Widget>[
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: GAME_PAD_MATRIX_W, childAspectRatio: 1),
                itemCount: GAME_PAD_MATRIX_H * GAME_PAD_MATRIX_W,
                itemBuilder: (context, index) {
                  List<int> xy = [];
                  int x, y = 0;
                  x = (index / GAME_PAD_MATRIX_W).floor();
                  y = (index % GAME_PAD_MATRIX_H);
                  xy.add(x);
                  xy.add(y);
                  return GestureDetector(
                    child: rowSelected(x, y, width, xy, index),
                    onTap: () {
                      print("index ======> $index");
                      print("x ======> $x");
                      print("y ======> $y");
                    },
                  );
                },
              )
            ])));
  }

  rowSelected(int x, int y, double width, List<int> xy, int index) {
    Color color;

    // print("index ====>>>>> $index");
    if (snakePosition.contains(index)) {
      color = brickColors[1];
    } else {
      color = brickColors[0];
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox.fromSize(
              size: BrikSize2.of(context).size,
              child: Container(
                margin: EdgeInsets.all(0.05 * width),
                padding: EdgeInsets.all(0.1 * width),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.10 * width, color: color)),
                child: Container(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ],
    );
    // }
  }

  void startingSnake() {
    snakePosition = [153, 163, 173, 183];
  }

  getLatestSnake() {
    timer = Timer.periodic(Duration(milliseconds: 600), (t) {
      if (widget.screenBloc.isStoped == true) {
        t.cancel();
        widget.screenBloc.isStoped = false;
        getLatestSnake();
      }
      setState(() {
        print(
            "widget.screenBloc.direction ====> ${widget.screenBloc.direction}");
        switch (widget.screenBloc.direction) {
          case Direction.LEFT:
            var currentHeadPos = snakePosition;
            snakePosition.insert(0, currentHeadPos[0] - 1);
            snakePosition.removeLast();
            print("snakePosition ====>>>>> $snakePosition");
            break;

          case Direction.RIGHT:
            var currentHeadPos = snakePosition;
            snakePosition.insert(0, currentHeadPos[0] + 1);
            snakePosition.removeLast();

            print("snakePosition ====>>>>> $snakePosition");
            break;

          case Direction.UP:
            var currentHeadPos = snakePosition;
            snakePosition.insert(0, currentHeadPos[0] - 10);
            snakePosition.removeLast();

            print("snakePosition ====>>>>> $snakePosition");
            break;

          case Direction.DOWN:
            var currentHeadPos = snakePosition;
            snakePosition.insert(0, currentHeadPos[0] + 10);
            snakePosition.removeLast();

            print("snakePosition ====>>>>> $snakePosition");
            break;
        }
      });
    });
  }

  onTimeTick() {
    getLatestSnake();
    print("snakePosition =======> $snakePosition");
  }
}
