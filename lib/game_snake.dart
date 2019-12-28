import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_tetris/audios.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/main.dart';
import 'package:new_tetris/resourses/snake.dart';
import 'package:new_tetris/settings/settings.dart';


///the height of game pad
const GAME_PAD_MATRIX_H = 20;

///the width of game pad
const GAME_PAD_MATRIX_W = 10;

enum SnakePosition { left, right, down, up }

enum SettingsStates { closedSettings, openSettings }

class SnakeGame extends StatefulWidget {
  final Widget child;
  final ScreenBloc screenBloc;

  const SnakeGame({Key key, @required this.child, this.screenBloc})
      : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GameControl();
  }

  static GameControl of(BuildContext context) {
    final state = context.ancestorStateOfType(TypeMatcher<GameControl>());
    assert(state != null, "must wrap this context with [Game]");
    return state;
  }
}

///duration for show a line when reset
const _REST_LINE_DURATION = const Duration(milliseconds: 50);

const _LEVEL_MAX = 9;

const _LEVEL_MIN = 1;

const _SPEED = [
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 720),
  const Duration(milliseconds: 640),
  const Duration(milliseconds: 560),
  const Duration(milliseconds: 480),
  const Duration(milliseconds: 400),
  const Duration(milliseconds: 320),
  const Duration(milliseconds: 240),
  const Duration(milliseconds: 160),
];

class GameControl extends State<SnakeGame> with RouteAware {
  GameControl() {
    //inflate game pad data
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      _data.add(List.filled(GAME_PAD_MATRIX_W, 0));
      _mask.add(List.filled(GAME_PAD_MATRIX_W, 0));
    }
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
  void didPushNext() {
    //pause when screen is at background
    pause();
  }

  Point newPointPosition;
  var snakePosition;

  ///the gamer data
  final List<List<int>> _data = [];

  final List<List<int>> _mask = [];

  ///from 1-6
  int _level = 1;

  int _points = 0;

  int _cleared = 0;

  // Block _getNext() {
  //   final next = _next;
  //   _next = Block.getRandom();
  //   return next;
  // }

  Snake _current;

  Snake _next = Snake.getRandom();

  SnakePosition _snakePosition = SnakePosition.down;
  SettingsStates _settinngsStates = SettingsStates.closedSettings;

  Snake _getNext() {
    final next = _next;
    _next = Snake.getRandom();
    return next;
  }

  SoundState get _sound => Sound.of(context);

  void up() {
    // setState(() {
    _snakePosition = SnakePosition.up;
    // });
  }

  void right() {
    // setState(() {
    _snakePosition = SnakePosition.right;
    // });
  }

  void left() {
    // setState(() {
    _snakePosition = SnakePosition.left;
    // });
  }

  void down() {
    // setState(() {
    _snakePosition = SnakePosition.down;
    // });
  }

  void drop() async {
    if (widget.screenBloc.states == GameStates.runningSnake &&
        _current != null) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current.down(step: i + 1);
        if (!fall.isValidInMatrix(_data)) {
          _current = _current.down(step: i);
          widget.screenBloc.states = GameStates.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          // _autoFall(true);
          _mixCurrentIntoData();
          break;
        }
      }
      setState(() {});
    } else if (widget.screenBloc.states == GameStates.paused ||
        widget.screenBloc.states == GameStates.selectedSnake) {
      _startGame();
    }
  }

  void downPosition({bool enableSounds = true}) {
    if (widget.screenBloc.states == GameStates.selectedSnake &&
        _level > _LEVEL_MIN) {
      _level--;
    } else if (widget.screenBloc.states == GameStates.runningSnake &&
        _current != null) {
      final next = _current.down();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          _sound.move();
        }
      } else {
        //    _autoFall(true);
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void upMovement({bool enableSounds = true}) {
    if (widget.screenBloc.states == GameStates.selectedSnake &&
        _level > _LEVEL_MIN) {
      _level--;
    } else if (widget.screenBloc.states == GameStates.runningSnake &&
        _current != null) {
      final next = _current.up();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          _sound.move();
        }
      } else {
        //   _autoFall(true);
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void leftPosition({bool enableSounds = true}) {
    if (widget.screenBloc.states == GameStates.selectedSnake &&
        _level > _LEVEL_MIN) {
      _level--;
    } else if (widget.screenBloc.states == GameStates.runningSnake &&
        _current != null) {
      final next = _current.left();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          _sound.move();
        }
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void rightPosition({bool enableSounds = true}) {
    if (widget.screenBloc.states == GameStates.selectedSnake &&
        _level > _LEVEL_MIN) {
      _level--;
    } else if (widget.screenBloc.states == GameStates.runningSnake &&
        _current != null) {
      final next = _current.right();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          _sound.move();
        }
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  Timer _autoFallTimer;

  // /mix current into [_data]
  Future<void> _mixCurrentIntoData({void mixSound()}) async {
    if (_data[0].contains(1)) {
      reset();
      _snakePosition = SnakePosition.down;
      return;
    } else {
      reset();
      _snakePosition = SnakePosition.down;
    }
  }

  // static void _forTable(dynamic function(int row, int column)) {
  //   for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
  //     for (int j = 0; j < GAME_PAD_MATRIX_W; j++) {
  //       final b = function(i, j);
  //       if (b is bool && b) {
  //         break;
  //       }
  //     }
  //   }
  // }

  void _autoFall(bool enable) {
    if (!enable && _autoFallTimer != null) {
      _autoFallTimer.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      _autoFallTimer = Timer.periodic(_SPEED[_level - 1], (t) {
        if (_snakePosition == SnakePosition.down) {
          downPosition(enableSounds: false);
        } else if (_snakePosition == SnakePosition.up) {
          upMovement(enableSounds: false);
        } else if (_snakePosition == SnakePosition.left) {
          leftPosition();
        } else if (_snakePosition == SnakePosition.right) {
          rightPosition();
        }
      });
    }
  }

  void pause() {
    if (widget.screenBloc.states == GameStates.runningSnake) {
      widget.screenBloc.states = GameStates.paused;
    }
  }

  void pauseOrResume() {
    if (widget.screenBloc.states == GameStates.runningSnake) {
      pause();
    } else if (widget.screenBloc.states == GameStates.paused ||
        widget.screenBloc.states == GameStates.selectedSnake) {
      _startGame();
    }
  }

  void reset() {
    if (widget.screenBloc.states == GameStates.selectedSnake) {
      //可以开始游戏
      _startGame();
      return;
    }
    if (widget.screenBloc.states == GameStates.reset) {
      return;
    }
    _sound.start();
    widget.screenBloc.states = GameStates.reset;
    () async {
      int line = GAME_PAD_MATRIX_H;
      await Future.doWhile(() async {
        line--;
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 1;
        }
        setState(() {});
        await Future.delayed(_REST_LINE_DURATION);
        return line != 0;
      });
      _current = null;
      _getNext();
      _points = 0;
      _cleared = 0;
      await Future.doWhile(() async {
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 0;
        }
        setState(() {});
        line++;
        await Future.delayed(_REST_LINE_DURATION);
        return line != GAME_PAD_MATRIX_H;
      });
      setState(() {
        widget.screenBloc.states = GameStates.selectedSnake;
      });
    }();
  }

  void _startGame() {
    if (widget.screenBloc.states == GameStates.runningSnake &&
        _autoFallTimer?.isActive == false) {
      return;
    }
    widget.screenBloc.states = GameStates.runningSnake;
    _autoFall(true);
    setState(() {});
  }

  settings(ScreenBloc screenBloc) {
    // GameStates gameState = _states;
    debugPrint("_settinngsStates : $_settinngsStates");

    if (_settinngsStates == SettingsStates.openSettings) {
      screenBloc.settingsScreen.add(null);
      _settinngsStates = SettingsStates.closedSettings;
    } else {
      screenBloc.settingsScreen.add(Settings());
      setState(() {
        _settinngsStates = SettingsStates.openSettings;
        pause();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> mixed = [];
    for (var i = 0; i < GAME_PAD_MATRIX_H; i++) {
      mixed.add(List.filled(GAME_PAD_MATRIX_W, 0));
      for (var j = 0; j < GAME_PAD_MATRIX_W; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    debugPrint("game states : ${widget.screenBloc.states}");
    return SnakeGameState(mixed, widget.screenBloc.states, _level, _sound.mute,
        _points, _cleared, _next,
        child: widget.child);
  }

  void soundSwitch() {
    setState(() {
      _sound.mute = !_sound.mute;
    });
  }
}

class SnakeGameState extends InheritedWidget {
  SnakeGameState(this.data, this.states, this.level, this.muted, this.points,
      this.cleared, this.next,
      {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;

  /// Экранные данные отображения
  /// 0: пустые кирпичи
  /// 1: обычные кирпичи
  /// 2: выделите кирпичи
  final List<List<int>> data;

  final GameStates states;

  final int level;

  final bool muted;

  final int points;

  final int cleared;

  final Snake next;

  static SnakeGameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SnakeGameState)
        as SnakeGameState);
  }

  @override
  bool updateShouldNotify(SnakeGameState oldWidget) {
    return true;
  }
}
