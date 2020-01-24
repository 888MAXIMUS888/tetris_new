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
  resume
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
  SettingsStates settinngsStates = SettingsStates.closedSettings;

  int level = 1;

  int points = 0;

  List<int> snakePosition = [];

  Direction direction = Direction.UP;
  bool mute = false;
  // var gameState = GameState.NONE;
  bool isStoped = false;
  

  final settingsScreen = BehaviorSubject();
  final openSettings = BehaviorSubject<bool>();
  final typeGame = BehaviorSubject.seeded("tetris");
  final gameStates = BehaviorSubject();
  final snakeGameStates = BehaviorSubject.seeded(GameStates.none);
  final gamePoints = BehaviorSubject.seeded(0);
  final gameLevel = BehaviorSubject.seeded(1);
  final snakeLength = BehaviorSubject.seeded(3);
  final numberLevel = BehaviorSubject();

  Observable get outSettingsScreen => settingsScreen.stream;
  Observable<bool> get outOpenSettings => openSettings.stream;
  Observable get outTypeGame => typeGame.stream;
  Observable get outGameState => gameStates.stream;
  Observable get outSnakeGameState => snakeGameStates.stream;
  Observable get outGamePoints => gamePoints.stream;
  Observable get outGameLevel => gameLevel.stream;
  Observable get outSnakeLength => snakeLength.stream;
  Observable get outNumberLevel => numberLevel.stream;

  void drop(settingsBloc, context) async {
    if (settinngsStates == SettingsStates.openSettings) {
      settingsBloc.setThemeIndex();
      settingsBloc.initialThem(context);
    } else {
      snakeGameStates.add(GameStates.runningSnake);
      states = GameStates.selectedTetris;
      typeGame.add(null);
    }
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
    if (settinngsStates == SettingsStates.closedSettings) {
      direction = Direction.RIGHT;
      isStoped = true;
    } else {
      settingsBloc.changeRightThem();
    }
  }

  void leftButton(settingsBloc) {
    if (settinngsStates == SettingsStates.closedSettings) {
      direction = Direction.LEFT;
      isStoped = true;
    } else {
      settingsBloc.changeLeftThem();
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
    if (settinngsStates == SettingsStates.closedSettings) {
      settinngsStates = SettingsStates.openSettings;
      settingsScreen.add(Settings());
    } else {
      settinngsStates = SettingsStates.closedSettings;
      settingsScreen.add(null);
    }
  }

  void startingSnake() {
    snakePosition = [63, 73, 83];
  }

  gameProgress() async{
    points += 100;
    snakeLength.add(snakePosition.length);
    gamePoints.add(points);
    if (snakePosition.length == 4) {
      level += 1;
      gameLevel.add(level);
      startingSnake();
      snakeLength.add(snakePosition.length);
     
      // states = GameStates.paused;
      numberLevel.add(level);
      snakeGameStates.add(GameStates.paused);
      await Future.delayed(Duration(milliseconds: 2000));
      // states = GameStates.runningSnake;
      numberLevel.add(null);
      snakeGameStates.add(GameStates.runningSnake);
      // states.
    }
  }

  restartStatusPanel() {
    points = 0;
    level = 1;
    gamePoints.add(points);
    gameLevel.add(level);
  }

  resetButton(){
    snakeGameStates.add(GameStates.reset);
  }

  soundSwitch(){
    mute = !mute;
    print("mute ========================>>>>>>>>>>>>>>>>> $mute");
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
  }
}
