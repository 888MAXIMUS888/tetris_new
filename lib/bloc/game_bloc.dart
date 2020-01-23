import 'package:rxdart/rxdart.dart';

enum TypeGame { tetris, snake }

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { NONE, START, RUNNING, FAILURE }

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

  Direction direction = Direction.UP;
  var gameState = GameState.NONE;
  bool isStoped = false;

  final settingsScreen = BehaviorSubject();
  final openSettings = BehaviorSubject<bool>();
  final typeGame = BehaviorSubject.seeded("tetris");
  final gameStates = BehaviorSubject();
  final snakeGameStates = BehaviorSubject.seeded(GameState.NONE);

  Observable get outSettingsScreen => settingsScreen.stream;
  Observable<bool> get outOpenSettings => openSettings.stream;
  Observable get outTypeGame => typeGame.stream;
  Observable get outGameState => gameStates.stream;
  Observable get outSnakeGameState => snakeGameStates.stream;

  void drop() async {
    snakeGameStates.add(GameState.START);
    states = GameStates.selectedTetris;
    typeGame.add(null);
  }

  snakeGame() {
    typeGame.add("snake");
  }

  tetrisGame() {
    typeGame.add("tetris");
  }

  void up() {
    direction = Direction.UP;
    isStoped = true;
  }

  void right() {
    direction = Direction.RIGHT;
    isStoped = true;
  }

  void left() {
    direction = Direction.LEFT;
    isStoped = true;
  }

  void down() {
    direction = Direction.DOWN;
    isStoped = true;
  }

  void dispose() {
    settingsScreen.close();
    openSettings.close();
    typeGame.close();
    gameStates.close();
    snakeGameStates.close();
  }
}
