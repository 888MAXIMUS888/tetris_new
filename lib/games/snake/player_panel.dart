import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_tetris/audios.dart';
import 'package:new_tetris/bloc/bloc_provider.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/bloc/settings_bloc.dart';
import 'package:new_tetris/main.dart';

const _COLOR_NORMAL = Colors.black87;

const _COLOR_NULL = Colors.black12;

const _COLOR_HIGHLIGHT = Color(0xFF560000);

const _PLAYER_PANEL_PADDING = 6;

const GAME_PAD_MATRIX_W = 10;

const GAME_PAD_MATRIX_H = 20;

const _REST_LINE_DURATION = const Duration(milliseconds: 50);

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
  final Random _random = Random();

  int brickPoint;
  Timer timer;

  Offset offset;
  int x;
  int y;
  var widthPosition;
  var heightPosition;
  List<int> _data = [];
  SoundState get _sound => Sound.of(context);

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    widget.screenBloc.snakeGameStates.listen((states) {
      print("states states states states states ===> $states");
      if (states == GameStates.runningSnake) {
        widget.screenBloc.startingSnake();
        generateBrick();
        getLatestSnake();
      } else if (states == GameStates.failure) {
        timer.cancel();
        widget.screenBloc.restartStatusPanel();
      } else if (states == GameStates.paused) {
        timer.cancel();
      } else if (states == GameStates.resume) {
        getLatestSnake();
      } else if (states == GameStates.reset) {
        timer.cancel();
        restart();
        widget.screenBloc.restartStatusPanel();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = BrikSize2.of(context).size.width;
    widget.screenBloc.mute ? _sound.mute = true : _sound.mute = false;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        SizedBox.fromSize(
            size: Size(widget.playerPanelWidth, widget.playerPanelWidth * 2),
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Stack(children: <Widget>[
                  GridView.builder(
                    key: _globalKey,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: GAME_PAD_MATRIX_W, childAspectRatio: 1),
                    itemCount: GAME_PAD_MATRIX_W * GAME_PAD_MATRIX_H,
                    itemBuilder: (context, index) {
                      List<int> xy = [];
                      // int x, y = 0;
                      x = (index / GAME_PAD_MATRIX_W).floor();
                      y = (index % GAME_PAD_MATRIX_H);
                      xy.add(x);
                      xy.add(y);
                      return GestureDetector(
                        child: rowSelected(x, y, width, xy, index, _globalKey),
                        onTapDown: (details) {
                          var widthPosition =
                              (index % GAME_PAD_MATRIX_W).floor();
                          var heightPosition =
                              (index % GAME_PAD_MATRIX_H).floor();
                          print("widthPosition ======> $widthPosition");
                          print("heightPosition ======> $heightPosition");
                          print("index ======> $index");
                        },
                      );
                    },
                  )
                ]))),
        StreamBuilder(
          stream: widget.screenBloc.outTypeGame,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Center(
                  child: Text(
                snapshot.data.toString(),
                style: TextStyle(fontSize: 20),
              ));
            } else {
              return Container();
            }
          },
        ),
        StreamBuilder(
          stream: widget.screenBloc.outNumberLevel,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Center(
                  child: Text(
                "Level ${snapshot.data}",
                style: TextStyle(fontSize: 20),
              ));
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  rowSelected(int x, int y, double width, List<int> xy, int index, globalKey) {
    Color color;
    if (widget.screenBloc.snakePosition.contains(index) ||
        brickPoint == index ||
        _data.contains(index)) {
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
  }

  getLatestSnake() {
    timer = Timer.periodic(SPEED[widget.screenBloc.level], (t) {
      if (widget.screenBloc.isStoped == true) {
        t.cancel();
        widget.screenBloc.isStoped = false;
        getLatestSnake();
      }
      setState(() {
        widthPosition =
            (widget.screenBloc.snakePosition[0] % GAME_PAD_MATRIX_W).floor();
        heightPosition =
            (widget.screenBloc.snakePosition[1] % GAME_PAD_MATRIX_H).floor();
        widget.screenBloc.states = GameStates.runningSnake;
        print(
            "widget.screenBloc.states  ====>>>>> ${widget.screenBloc.states}");
        switch (widget.screenBloc.direction) {
          case Direction.LEFT:
            var currentHeadPos = widget.screenBloc.snakePosition;
            widget.screenBloc.snakePosition.insert(0, currentHeadPos[0] - 1);
            widget.screenBloc.snakePosition.removeLast();
            _sound.move();
            failureSnake();

            print("widthPosition ====>>>>> $widthPosition");
            print("heightPosition ====>>>>> $heightPosition");
            break;

          case Direction.RIGHT:
            var currentHeadPos = widget.screenBloc.snakePosition;
            widget.screenBloc.snakePosition.insert(0, currentHeadPos[0] + 1);
            widget.screenBloc.snakePosition.removeLast();
            _sound.move();

            failureSnake();
            print("widthPosition ====>>>>> $widthPosition");
            print("heightPosition ====>>>>> $heightPosition");
            break;

          case Direction.UP:
            var currentHeadPos = widget.screenBloc.snakePosition;
            widget.screenBloc.snakePosition.insert(0, currentHeadPos[0] - 10);
            widget.screenBloc.snakePosition.removeLast();
            _sound.move();

            failureSnake();
            print("widthPosition ====>>>>> $widthPosition");
            print("heightPosition ====>>>>> $heightPosition");
            break;

          case Direction.DOWN:
            var currentHeadPos = widget.screenBloc.snakePosition;
            widget.screenBloc.snakePosition.insert(0, currentHeadPos[0] + 10);
            widget.screenBloc.snakePosition.removeLast();
            _sound.move();

            failureSnake();
            print("widthPosition ====>>>>> $widthPosition");
            print("heightPosition ====>>>>> $heightPosition");
            break;
        }
      });
    });
  }

  failureSnake() {
    if (widget.screenBloc.snakePosition[0] < 0 ||
        widget.screenBloc.snakePosition[0] > 199 ||
        widthPosition == 0 && heightPosition == 19 ||
        widthPosition == 0 && heightPosition == 9 ||
        widthPosition == 9 && heightPosition == 10 ||
        widthPosition == 19 && heightPosition == 0) {
      widget.screenBloc.snakePosition.removeRange(0, 2);
      widget.screenBloc.snakeGameStates.add(GameStates.failure);

      restart();
    } else if (widget.screenBloc.snakePosition[0] == brickPoint) {
      widget.screenBloc.snakePosition.add(brickPoint);
      _sound.clear();
      widget.screenBloc.gameProgress();

      generateBrick();
    }
  }

  generateBrick() {
    brickPoint = _random.nextInt(199);
  }

  restart() async {
    _sound.start();
    List<int> line = [];
    int inde = 200;
    var index = -1;

    await Future.doWhile(() async {
      for (var i = 0; i < 10; i++) {
        inde -= 1;
        line.add(inde);
      }
      for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
        _data = line.toSet().toList();
      }
      setState(() {});
      await Future.delayed(_REST_LINE_DURATION);

      return !_data.contains(0);
    });

    await Future.doWhile(() async {
      List<int> list = [];

      for (var i = 0; i < 10; i++) {
        index += 1;
        list.add(index);
      }
      for (var i = 0; i < 10; i++) {
        list.forEach((data1) => _data.removeWhere((data) => data == data1));
      }

      setState(() {});
      await Future.delayed(_REST_LINE_DURATION);
      widget.screenBloc.snakePosition.clear();
      brickPoint = null;
      widget.screenBloc.snakeGame();
      return _data.contains(199);
    });
  }
}
