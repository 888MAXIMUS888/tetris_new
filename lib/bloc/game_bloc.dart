import 'dart:async';

import 'package:rxdart/rxdart.dart';

enum TypeGame {tetris, snake}

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState {NONE, START, RUNNING, FAILURE }


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




class ScreenBloc {

  TypeGame typeGameSelected = TypeGame.tetris;
  GameStates states = GameStates.selectedTetris;

  Direction direction = Direction.RIGHT;
  var gameState = GameState.NONE;

  final settingsScreen = BehaviorSubject();
  final openSettings = BehaviorSubject<bool>();
  final typeGame = BehaviorSubject.seeded("tetris");
  final gameStates = BehaviorSubject();
  final snakeGameStates = BehaviorSubject.seeded(Direction.DOWN);

  Observable get outSettingsScreen => settingsScreen.stream;
  Observable<bool> get outOpenSettings => openSettings.stream;
  Observable get outTypeGame => typeGame.stream;
  Observable get outGameState => gameStates.stream;
  Observable get outSnakeGameState => snakeGameStates.stream;


  void drop() async {
    // setState(() {
    // states = GameStates.runningSnake;
    
    states = GameStates.selectedTetris;
    gameState = GameState.START;
    // snakeGameStates.add(GameState.START);
    // });
  }


     void up() {
    // direction = Direction.UP;
    snakeGameStates.add(Direction.UP);
  }

  void right() {
   snakeGameStates.add(Direction.RIGHT);
  }

  void left() {
    snakeGameStates.add(Direction.LEFT);
  }

  void down() {
    snakeGameStates.add(Direction.DOWN);
  }

  void dispose() {
    settingsScreen.close();
    openSettings.close();
    typeGame.close();
    gameStates.close();
    snakeGameStates.close();
  }
}