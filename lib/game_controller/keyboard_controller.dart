import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
// import 'package:new_tetris/games/snake.dart';
import 'package:new_tetris/games/tetris.dart';

class KeyboardController extends StatefulWidget {
  final Widget child;
  final ScreenBloc screenBloc;

  KeyboardController({this.child, this.screenBloc});

  @override
  _KeyboardControllerState createState() => _KeyboardControllerState();
}

class _KeyboardControllerState extends State<KeyboardController> {

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
    final tetrisGame = TetrisGame.of(context);
    // final snakeGame = PlayerPanel.of(context);
    
    if(widget.screenBloc.typeGameSelected == TypeGame.tetris){
      keyboardEvent(key, tetrisGame);
    } else {
      keyboardEvent2(key);
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

  keyboardEvent(key, gameSelect){
    print("widget.screenBloc.typeGameSelected ===>>> ${widget.screenBloc.typeGameSelected}");
      if (key == PhysicalKeyboardKey.arrowUp) {
      gameSelect.up();
    } else if (key == PhysicalKeyboardKey.arrowDown) {
      gameSelect.down();
    } else if (key == PhysicalKeyboardKey.arrowLeft) {
      gameSelect.left();
    } else if (key == PhysicalKeyboardKey.arrowRight) {
      gameSelect.right();
    } else if (key == PhysicalKeyboardKey.space) {
      gameSelect.drop();
    } else if (key == PhysicalKeyboardKey.keyP) {
      gameSelect.pauseOrResume();
    } else if (key == PhysicalKeyboardKey.keyS) {
      gameSelect.soundSwitch();
    } else if (key == PhysicalKeyboardKey.keyR) {
      gameSelect.reset();
    }
    }

    keyboardEvent2(key){
    print("widget.screenBloc.typeGameSelected ===>>> ${widget.screenBloc.typeGameSelected}");
      if (key == PhysicalKeyboardKey.arrowUp) {
      // widget.screenBloc.up();
      widget.screenBloc.up();
      setState(() {
        
      });
    } else if (key == PhysicalKeyboardKey.arrowDown) {
      // gameSelect.down();
      widget.screenBloc.down();
       setState(() {
        
      });
    } else if (key == PhysicalKeyboardKey.arrowLeft) {
      // gameSelect.left();
      widget.screenBloc.left();
       setState(() {
        
      });
    } else if (key == PhysicalKeyboardKey.arrowRight) {
      // gameSelect.right();
      widget.screenBloc.right();
       setState(() {
        
      });
    } else if (key == PhysicalKeyboardKey.space) {
      // gameSelect.drop();
      widget.screenBloc.drop();
    } else if (key == PhysicalKeyboardKey.keyP) {
      // gameSelect.pauseOrResume();
    } else if (key == PhysicalKeyboardKey.keyS) {
      // gameSelect.soundSwitch();
    } else if (key == PhysicalKeyboardKey.keyR) {
      // gameSelect.reset();
    }
    }
}
