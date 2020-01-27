import 'package:new_tetris/bloc/settings_bloc.dart';
import 'package:new_tetris/settings/settings.dart';
import 'package:rxdart/rxdart.dart';

enum TypeGame { tetris, snake }

enum Direction { LEFT, RIGHT, UP, DOWN }
enum SettingsStates { closedSettings, openSettings }

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
  failure,
  resume,
  // speedUp,
  // speedOff
  speed
}

const LEVEL_MAX = 9;

const LEVEL_MIN = 1;

const SPEED = [
  const Duration(milliseconds: 800),
  const Duration(milliseconds: 700),
  const Duration(milliseconds: 620),
  const Duration(milliseconds: 540),
  const Duration(milliseconds: 460),
  const Duration(milliseconds: 400),
  const Duration(milliseconds: 320),
  const Duration(milliseconds: 240),
  const Duration(milliseconds: 160),
];

class ScreenBloc {
  TypeGame typeGameSelected = TypeGame.tetris;
  GameStates states = GameStates.selectedTetris;
  SettingsStates settingsStates = SettingsStates.closedSettings;

  int level = 1;
  int snakeSpeed = 1;

  int points = 0;

  List<int> snakePosition = [];
  List<int> snakeData = [];

  Direction direction = Direction.UP;
  bool mute = false;
  bool isStoped = false;

  final settingsScreen = BehaviorSubject();
  final openSettings = BehaviorSubject<bool>();
  final typeGame = BehaviorSubject.seeded("tetris");
  final titleGame = BehaviorSubject.seeded("tetris");
  final gameStates = BehaviorSubject();
  final snakeGameStates = BehaviorSubject.seeded(GameStates.none);
  final gamePoints = BehaviorSubject.seeded(0);
  final gameLevel = BehaviorSubject.seeded(1);
  final snakeLength = BehaviorSubject.seeded(3);
  final numberLevel = BehaviorSubject();

  Observable get outSettingsScreen => settingsScreen.stream;
  Observable<bool> get outOpenSettings => openSettings.stream;
  Observable get outTypeGame => typeGame.stream;
  Observable get outTitleGame => titleGame.stream;
  Observable get outGameState => gameStates.stream;
  Observable get outSnakeGameState => snakeGameStates.stream;
  Observable get outGamePoints => gamePoints.stream;
  Observable get outGameLevel => gameLevel.stream;
  Observable get outSnakeLength => snakeLength.stream;
  Observable get outNumberLevel => numberLevel.stream;

  void drop(settingsBloc, context) async {
    if (settingsStates == SettingsStates.openSettings) {
      settingsBloc.setThemeIndex();
      settingsBloc.initialThem(context);
    } else if(states == GameStates.runningSnake){
      // snakeGameStates.add(GameStates.speedUp);
      
      print("Heeeeeellllllloooooo");
    }
    else {
      snakeGameStates.add(GameStates.runningSnake);
      states = GameStates.selectedTetris;
      typeGame.add(null);
    }
  }

  void speedUp(){
    snakeSpeed = 8;
    snakeGameStates.add(GameStates.speed);
  }

  void speedOff(){
    snakeSpeed = level;
    snakeGameStates.add(GameStates.speed);
  }

  snakeGame() {
    typeGame.add("snake");
  }

  tetrisGame() {
    typeGame.add("tetris");
  }

  void upButton() {
    direction = Direction.UP;
    isStoped = true;
  }

  void rightButton(settingsBloc) {
    print("settinngsStates  $settingsStates");
    if (states == GameStates.runningSnake) {
      direction = Direction.RIGHT;
      isStoped = true;
    } else if (settingsStates == SettingsStates.openSettings) {
      settingsBloc.changeRightThem();
    } else if (typeGameSelected == TypeGame.tetris ||
        states == GameStates.selectedTetris) {
      typeGame.add("snake");
      typeGameSelected = TypeGame.snake;
      states = GameStates.selectedSnake;
    } else if (typeGameSelected == TypeGame.snake ||
        states == GameStates.selectedSnake) {
      typeGame.add("tetris");
      typeGameSelected = TypeGame.tetris;
      states = GameStates.selectedTetris;
    } else {
      settingsBloc.changeRightThem();
    }
  }

  void leftButton(settingsBloc) {
    if (states == GameStates.runningSnake) {
      direction = Direction.LEFT;
      isStoped = true;
    } else if (settingsStates == SettingsStates.openSettings) {
      settingsBloc.changeLeftThem();
    } else if (typeGameSelected == TypeGame.tetris ||
        states == GameStates.selectedTetris) {
      typeGame.add("snake");
    } else if (typeGameSelected == TypeGame.snake ||
        states == GameStates.selectedSnake) {
      typeGame.add("tetris");
      typeGameSelected = TypeGame.tetris;
      states = GameStates.selectedTetris;
    }
  }

  void downButton() {
    direction = Direction.DOWN;
    isStoped = true;
  }

  void pause() {
    if (states == GameStates.runningSnake) {
      states = GameStates.paused;
      snakeGameStates.add(GameStates.paused);
    }
  }

  void resumeGame() {
    states = GameStates.runningSnake;
    snakeGameStates.add(GameStates.resume);
  }

  void pauseOrResumeButton() {
    if (states == GameStates.runningSnake) {
      pause();
    } else if (states == GameStates.paused) {
      resumeGame();
    }
  }

  settingsButton() {
    pauseOrResumeButton();
    openSettingsScreen = !openSettingsScreen;
    if (settingsStates == SettingsStates.closedSettings) {
      settingsStates = SettingsStates.openSettings;
      settingsScreen.add(Settings());
      // typeGame.add(null);
      states = GameStates.selectedSnake;
      
    } else {
      settingsStates = SettingsStates.closedSettings;
      settingsScreen.add(null);
    }
  }

  void startingSnake() {
    snakePosition = [53, 63, 73];
  }

  gameProgress() async {
    points += 100;
    snakeLength.add(snakePosition.length);
    gamePoints.add(points);
    if (snakePosition.length == 10) {
      level += 1;
      snakeSpeed = level;
      gameLevel.add(snakeSpeed);
      startingSnake();
      snakeLength.add(snakePosition.length);
      numberLevel.add(snakeSpeed);
      snakeGameStates.add(GameStates.paused);
      await Future.delayed(Duration(milliseconds: 2000));
      numberLevel.add(null);
      snakeGameStates.add(GameStates.runningSnake);
    }
  }

  restartStatusPanel() {
    points = 0;
    level = 1;
    gamePoints.add(points);
    gameLevel.add(level);
  }

  resetButton() {
    snakeGameStates.add(GameStates.reset);
    states = GameStates.selectedSnake;
  }

  soundSwitch() {
    mute = !mute;
  }

  void dispose() {
    settingsScreen.close();
    openSettings.close();
    typeGame.close();
    gameStates.close();
    snakeGameStates.close();
    gamePoints.close();
    gameLevel.close();
    snakeLength.close();
    numberLevel.close();
    titleGame.close();
  }
}
