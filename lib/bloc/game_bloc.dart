import 'package:new_tetris/gamer.dart';
import 'package:rxdart/rxdart.dart';

enum TypeGame {tetris, snake}

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

  final settingsScreen = BehaviorSubject();
  final openSettings = BehaviorSubject<bool>();
  final typeGame = BehaviorSubject.seeded("tetris");
  final gameState = BehaviorSubject();

  Observable get outSettingsScreen => settingsScreen.stream;
  Observable<bool> get outOpenSettings => openSettings.stream;
  Observable get outTypeGame => typeGame.stream;
  Observable get outGameState => gameState.stream;

  void dispose() {
    settingsScreen.close();
    openSettings.close();
    typeGame.close();
    gameState.close();
  }
}