import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:tetris/bloc/screen_bloc.dart';
// import 'package:tetris/gamer/block.dart';
// import 'package:tetris/main.dart';
// import 'package:tetris/material/audios.dart';
// import 'package:tetris/settings/settings.dart';

import 'snake.dart';

///the height of game pad
const GAME_PAD_MATRIX_H = 20;

///the width of game pad
const GAME_PAD_MATRIX_W = 10;

///state of [GameControl]
enum GameStates {
  none,
  selectedTetris,
  selectedSnake,
  paused,
  runningTetris,
  runningSnake,
  reset,
  mixing,
  clear,
  drop,
}

enum SnakePosition { left, right, down, up }

enum SettingsStates { closedSettings, openSettings }

class SnakeGame extends StatefulWidget {
  final Widget child;

  const SnakeGame({Key key, @required this.child})
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
    // routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
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

  // Block _current;

  // Block _next = Block.getRandom();

  // GameStates _states = GameStates.selectedTetris;
  // SettingsStates _settinngsStates = SettingsStates.closedSettings;

  // Block _getNext() {
  //   final next = _next;
  //   _next = Block.getRandom();
  //   return next;
  // }

  Snake _current;

  Snake _next = Snake.getRandom();

  GameStates _states = GameStates.selectedTetris;
  SnakePosition _snakePosition = SnakePosition.down;
  SettingsStates _settinngsStates = SettingsStates.closedSettings;

  Snake _getNext() {
    final next = _next;
    _next = Snake.getRandom();
    return next;
  }

  // SoundState get _sound => Sound.of(context);

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
    if (_states == GameStates.runningTetris && _current != null) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current.down(step: i + 1);
        if (!fall.isValidInMatrix(_data)) {
          _current = _current.down(step: i);
          _states = GameStates.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          // _autoFall(true);
          _mixCurrentIntoData();
          break;
        }
      }
      setState(() {});
    } else if (_states == GameStates.paused ||
        _states == GameStates.selectedTetris) {
      _startGame();
    }
  }

  void downPosition({bool enableSounds = true}) {
    if (_states == GameStates.selectedTetris && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.down();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          // _sound.move();
        }
      } else {
        //    _autoFall(true);
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void upMovement({bool enableSounds = true}) {
    if (_states == GameStates.selectedTetris && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.up();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          // _sound.move();
        }
      } else {
        //   _autoFall(true);
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void leftPosition({bool enableSounds = true}) {
    if (_states == GameStates.selectedTetris && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.left();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          // _sound.move();
        }
      } else {
        _mixCurrentIntoData();
      }
    }
    setState(() {});
  }

  void rightPosition({bool enableSounds = true}) {
    if (_states == GameStates.selectedTetris && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.right();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        if (enableSounds) {
          // _sound.move();
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
    if (_states == GameStates.runningTetris) {
      _states = GameStates.paused;
    }
  }

  void pauseOrResume() {
    if (_states == GameStates.runningTetris) {
      pause();
    } else if (_states == GameStates.paused ||
        _states == GameStates.selectedTetris) {
      _startGame();
    }
  }

  void reset() {
    if (_states == GameStates.selectedTetris) {
      //可以开始游戏
      _startGame();
      return;
    }
    if (_states == GameStates.reset) {
      return;
    }
    // _sound.start();
    _states = GameStates.reset;
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
        _states = GameStates.selectedTetris;
      });
    }();
  }

  void _startGame() {
    if (_states == GameStates.runningTetris &&
        _autoFallTimer?.isActive == false) {
      return;
    }
    _states = GameStates.runningTetris;
    _autoFall(true);
    setState(() {});
  }

  // settings(ScreenBloc screenBloc) {
  //   // GameStates gameState = _states;
  //   debugPrint("_settinngsStates : $_settinngsStates");

  //   if (_settinngsStates == SettingsStates.openSettings) {
  //     screenBloc.settingsScreen.add(null);
  //     _settinngsStates = SettingsStates.closedSettings;
  //   } else {
  //     screenBloc.settingsScreen.add(Settings());
  //     setState(() {
  //       _settinngsStates = SettingsStates.openSettings;
  //       pause();
  //     });
  //   }
  // }

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
    debugPrint("game states : $_states");
    return SnakeGameState(
        mixed, _states, _level, _points, _cleared, _next,
        child: widget.child);
  }

  void soundSwitch() {
    setState(() {
      // _sound.mute = !_sound.mute;
    });
  }
}

class SnakeGameState extends InheritedWidget {
  SnakeGameState(this.data, this.states, this.level, this.points,
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

  // final bool muted;

  final int points;

  final int cleared;

  final Snake next;

  static SnakeGameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SnakeGameState) as SnakeGameState);
  }

  @override
  bool updateShouldNotify(SnakeGameState oldWidget) {
    return true;
  }
}




///keyboard controller to play game
class KeyboardController2 extends StatefulWidget {
  final Widget child;

  KeyboardController2({this.child});

  @override
  _KeyboardController2State createState() => _KeyboardController2State();
}

class _KeyboardController2State extends State<KeyboardController2> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_onKey);
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      return;
    }

    final key = event.data.physicalKey;
    final game = SnakeGame.of(context);

    if (key == PhysicalKeyboardKey.arrowUp) {
      game.up();
    } else if (key == PhysicalKeyboardKey.arrowDown) {
      game.down();
    } else if (key == PhysicalKeyboardKey.arrowLeft) {
      game.left();
    } else if (key == PhysicalKeyboardKey.arrowRight) {
      game.right();
    } else if (key == PhysicalKeyboardKey.space) {
      game.drop();
    } else if (key == PhysicalKeyboardKey.keyP) {
      game.pauseOrResume();
    } else if (key == PhysicalKeyboardKey.keyS) {
      game.soundSwitch();
    } else if (key == PhysicalKeyboardKey.keyR) {
      game.reset();
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
