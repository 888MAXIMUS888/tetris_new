import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_tetris/main.dart';
import 'package:new_tetris/resourses/bloc.dart';
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
  drop
}

enum SettingsStates { closedSettings, openSettings }

class TetrisGame extends StatefulWidget {
  final Widget child;

  const TetrisGame({Key key, @required this.child})
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

class GameControl extends State<TetrisGame> with RouteAware {
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


  Block _current;

  Block _next = Block.getRandom();

  GameStates _states = GameStates.selectedTetris;
  SettingsStates _settinngsStates = SettingsStates.closedSettings;

  Block _getNext() {
    final next = _next;
    _next = Block.getRandom();
    return next;
  }

  // SoundState get _sound => Sound.of(context);

  void rotate() {
    if (_states == GameStates.selectedTetris && _level < _LEVEL_MAX) {
      _level++;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.rotate();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.rotate();
      }
    }
    setState(() {});
  }

  void right() {
    if (_states == GameStates.selectedTetris) {
      _states = GameStates.selectedSnake;
      print("selected snake");
    } else if (_states == GameStates.selectedSnake) {
      _states = GameStates.selectedTetris;
      print("selected tetris");
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.right();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.move();
      }
    }
    setState(() {});
  }

  void left() {
    if (_states == GameStates.selectedTetris) {
      _states = GameStates.selectedSnake;
      print("selected snake");
    } else if (_states == GameStates.selectedSnake) {
      _states = GameStates.selectedTetris;
      print("selected tetris");
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.left();
      if (next.isValidInMatrix(_data)) {
        _current = next;
        // _sound.move();
      }
    }
    setState(() {});
  }

  void drop() async {
    if (_states == GameStates.runningTetris && _current != null) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current.fall(step: i + 1);
        if (!fall.isValidInMatrix(_data)) {
          _current = _current.fall(step: i);
          _states = GameStates.drop;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
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

  void down({bool enableSounds = true}) {
    if (_states == GameStates.selectedTetris && _level > _LEVEL_MIN) {
      _level--;
    } else if (_states == GameStates.runningTetris && _current != null) {
      final next = _current.fall();
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

  ///mix current into [_data]
  Future<void> _mixCurrentIntoData({void mixSound()}) async {
    if (_current == null) {
      return;
    }
    //cancel the auto falling task
    _autoFall(false);

    _forTable((i, j) => _data[i][j] = _current.get(j, i) ?? _data[i][j]);

    final clearLines = [];
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      setState(() => _states = GameStates.clear);

      // _sound.clear();

      for (int count = 0; count < 5; count++) {
        clearLines.forEach((line) {
          _mask[line].fillRange(0, GAME_PAD_MATRIX_W, count % 2 == 0 ? 1 : 1);
        });
        setState(() {});
        await Future.delayed(Duration(milliseconds: 100));
      }
      clearLines
          .forEach((line) => _mask[line].fillRange(0, GAME_PAD_MATRIX_W, 0));

      clearLines.forEach((line) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(GAME_PAD_MATRIX_W, 0);
      });
      debugPrint("clear lines : $clearLines");

      _cleared += clearLines.length;
      _points += clearLines.length * _level * 5;

      //up level possible when cleared
      int level = (_cleared ~/ 50) + _LEVEL_MIN;
      _level = level <= _LEVEL_MAX && level > _level ? level : _level;
    } else {
      _states = GameStates.mixing;
      if (mixSound != null) mixSound();
      _forTable((i, j) => _mask[i][j] = _current.get(j, i) ?? _mask[i][j]);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 200));
      _forTable((i, j) => _mask[i][j] = 0);
      setState(() {});
    }

    _current = null;

    if (_data[0].contains(1)) {
      reset();
      return;
    } else {
      _startGame();
    }
  }

  static void _forTable(dynamic function(int row, int column)) {
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GAME_PAD_MATRIX_W; j++) {
        final b = function(i, j);
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  void _autoFall(bool enable) {
    if (!enable && _autoFallTimer != null) {
      _autoFallTimer.cancel();
      _autoFallTimer = null;
    } else if (enable) {
      _autoFallTimer?.cancel();
      _current = _current ?? _getNext();
      _autoFallTimer = Timer.periodic(_SPEED[_level - 1], (t) {
        down(enableSounds: false);
      });
    }
  }

  void pause() {
    if (_states == GameStates.runningTetris) {
      _states = GameStates.paused;
    }
    // setState(() {});
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
    return TetrisGameState(
        mixed, _states, _level, _points, _cleared, _next,
        child: widget.child);
  }

  void soundSwitch() {
    setState(() {
      // _sound.mute = !_sound.mute;
    });
  }
}

class TetrisGameState extends InheritedWidget {
  TetrisGameState(this.data, this.states, this.level, this.points,
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

  final Block next;

  static TetrisGameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TetrisGameState) as TetrisGameState);
  }

  @override
  bool updateShouldNotify(TetrisGameState oldWidget) {
    return true;
  }
}


class KeyboardController extends StatefulWidget {
  final Widget child;

  KeyboardController({this.child});

  @override
  _KeyboardController2State createState() => _KeyboardController2State();
}

class _KeyboardController2State extends State<KeyboardController> {
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
    final game = TetrisGame.of(context);

    if (key == PhysicalKeyboardKey.arrowUp) {
      game.rotate();
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

