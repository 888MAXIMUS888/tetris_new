import 'package:flutter/material.dart';
import 'package:new_tetris/game_controller/buttons/drop_button.dart';
import 'package:new_tetris/game_controller/buttons/system_buttons.dart';

class LeftController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SystemButtonGroup(),
        Expanded(
          child: Center(
            child: DropButton(),
          ),
        )
      ],
    );
  }
}
