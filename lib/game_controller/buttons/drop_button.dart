import 'package:flutter/material.dart';
import 'package:new_tetris/bloc/bloc_provider.dart';
import 'package:new_tetris/bloc/game_bloc.dart';
import 'package:new_tetris/bloc/settings_bloc.dart';
import 'package:new_tetris/game_controller/widgets/button.dart';
import 'package:new_tetris/game_controller/widgets/description.dart';
// import 'package:new_tetris/games/snake.dart';
import 'package:new_tetris/games/tetris.dart';
import 'package:new_tetris/snkk/player_panel.dart';

class DropButton extends StatelessWidget {
  final ScreenBloc screenBloc;

  DropButton({@required this.screenBloc});

  @override
  Widget build(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
    print("screenBloc.typeGameSelected => ${screenBloc.typeGameSelected}");
    return Description(
        text: 'drop',
        child: Button(
            color: Theme.of(context).buttonColor,
            enableLongPress: false,
            size: Size(90, 90),
            onTap: () {
              if (openSettingsScreen == true) {
                settingsBloc.setThemeIndex();
                settingsBloc.initialThem(context);
              } else if (screenBloc.typeGameSelected == TypeGame.tetris) {
                TetrisGame.of(context).drop();
              } else if (screenBloc.typeGameSelected == TypeGame.snake) {
                screenBloc.drop();
              }
            }));
  }
}
