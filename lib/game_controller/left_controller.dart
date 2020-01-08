import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/game_controller/buttons/drop_button.dart';
import 'package:new_tetris/game_controller/buttons/system_buttons.dart';

class LeftController extends StatelessWidget {

  final ScreenBloc screenBloc;
  LeftController({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SystemButtonGroup(screenBloc: screenBloc),
        Expanded(
          child: Center(
            child: DropButton(screenBloc: screenBloc),
          ),
        )
      ],
    );
  }
}
