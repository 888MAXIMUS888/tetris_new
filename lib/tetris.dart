import 'package:flutter/material.dart';
import 'package:new_tetris/game_controller/game_controller.dart';
import 'package:new_tetris/screen_decoration.dart';



class Tetris extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TetrisState();
  }
}

class TetrisState extends State<Tetris>{
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child:
  
    Container(
      padding: MediaQuery.of(context).padding,
      child: Column(children: <Widget>[
        Spacer(),
      ScreenDecoration(),
      Spacer(flex: 1,),
      GameController()
      ])));
  }
}



